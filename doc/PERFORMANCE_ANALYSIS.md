# 📊 تحليل الأداء واستهلاك الموارد — `frosted_ui_kit`

> تحليل ساكن (static analysis) لكامل `lib/` بتاريخ 2026-09-11 — على الإصدار `1.0.2`
> المرجع: `doc/FROSTED_UI_KIT.md` و `.agents/AGENTS.md`

---

## ✅ حالة التنفيذ — الإصدار 1.1.0

**تم تطبيق المرحلتين 1 و 2 بالكامل.** التقرير أدناه يصف المشكلة كما كانت في
`1.0.2`، ويُحتفظ به كمرجع تقني ولقياس الفرق قبل/بعد. تفاصيل التغييرات في
[CHANGELOG.md](../CHANGELOG.md).

| البند | الحالة | التنفيذ |
| :--- | :-: | :--- |
| مشاركة طبقة الخلفية بين كل عمليات الضبابية | ✅ | `FrostedGlassGroup` (`BackdropGroup` + `BackdropFilter.grouped`) — يُطبَّق تلقائياً من `BaseWidget` و `AppDialog` و `showAppBottomSheet` |
| مفتاح أداء عام لإطفاء/تخفيض الزجاج | ✅ | `FrostedPerformance` + الإعدادات الجاهزة `full` / `balanced` / `lite` |
| إخراج الأنيميشن من داخل الطبقة المضببة | ✅ | `FrostedPanel` — طُبِّق على شريط التنقل، التبويبات، الديالوغات، حقول النص، وقوائم `FrostedListSection` |
| Lottie داخل الزجاج | ✅ | `FrostLoadingButton.blurWhileLoading = false` + ديالوغ التحميل على `FrostedPanel` |
| مفاتيح تعطيل موضعية | ✅ | `enabled` / `grouped` على `BlurredCard` و `FrostedPanel`، و `blurEnabled` على الأزرار |
| خفض sigma في شريط التنقل | ✅ | من `20` إلى `12`، وصار قابلاً للضبط عبر `sigmaX` / `sigmaY` |
| `RepaintBoundary` | ✅ | حول طبقة الزجاج في `FrostedPanel` وحول كل عنصر في شريط التنقل |
| تخزين `AppThemes.border` مؤقتاً | ✅ | كاش حسب اللون بدل تخصيص كائن جديد كل إطار |
| حذف الـ `ClipRRect` المكرر في `FrostedListSection` | ✅ | — |
| تثبيت `material_ui` و `cupertino_ui` | ✅ | `^1.2.0` و `^1.0.2` بدل `any` |
| تغيير الأنماط الافتراضية (`colored` للأزرار، `useGlass: false`) | ⏳ | مؤجَّل لـ v2.0 — كاسر للتوافق |
| فصل `lottie` إلى حزمة مرافقة | ⏳ | مؤجَّل لـ v2.0 — كاسر للتوافق |
| نقل `lib/main.dart` و `features/home/` إلى `example/` | ⏳ | لم يُنفَّذ — أثره على وقت التشغيل صفر (tree-shaking) |

> ⚠️ **لم يتم تشغيل `flutter analyze` ولا القياس على جهاز فعلي** — بيئة التحليل
> ما بيها Flutter SDK. شغّل `flutter analyze` و `flutter run --profile` قبل النشر.

---

## 1. الخلاصة التنفيذية

**نعم — استخدام الحزمة يزيد استهلاك الموارد، والزيادة على الـ GPU وليس على الـ RAM.**

السبب الجذري واحد ومركزي: **كل مكوّن زجاجي في الحزمة مبني على `BlurredCard`، و`BlurredCard` تُنشئ `BackdropFilter` مستقل لكل نسخة منها.** يعني شاشة واحدة عادية تحتوي بين **5 و 11 عملية `BackdropFilter` منفصلة** في نفس الإطار (frame).

| البُعد | التقييم | الملاحظة |
| :--- | :--- | :--- |
| **GPU / وقت الرسم (raster)** | 🔴 مرتفع | المصدر الأساسي للمشكلة |
| **الذاكرة (RAM)** | 🟢 سليم | لا يوجد تسريب؛ لا `AnimationController` بدون `dispose` |
| **ذاكرة GPU المؤقتة** | 🟡 متوسط | ~3–6 MB لكل إطار على شاشة مزدحمة |
| **CPU / Dart** | 🟢 منخفض | تخصيصات بسيطة، لا حسابات ثقيلة في `build` |
| **حجم التطبيق** | 🟡 متوسط | `lottie` + `archive` + `http` مقابل ملف سبينر بحجم 3 KB |
| **صحة الحزمة (package health)** | 🟡 | `material_ui: any` و `cupertino_ui: any` + كود تجريبي منشور داخل المكتبة |

**الحكم حسب فئة الجهاز:**

- **أجهزة راقية** (iPhone 14+، Snapdragon 8 Gen 1+): مقبولة تماماً، 60/120fps تُحافظ عليها.
- **أجهزة متوسطة وضعيفة** (Snapdragon 4xx/6xx، Mali-G52/G57 — وهي **الغالبية في السوق العراقي**): هنا تظهر المشكلة فعلياً. توقّع ارتفاع زمن الإطار، jank أثناء التمرير، استهلاك بطارية وحرارة.

الخبر الجيد: **كل المشاكل قابلة للحل داخل `cards.dart` و `base_widget.dart` و `navigation_bar.dart` تقريباً** — أي بتعديل مركزي محدود، بدون إعادة كتابة الحزمة.

---

## 2. المصدر الحقيقي للكلفة — كيف تعمل الحزمة داخلياً

### 2.1 نقطة الاختناق المركزية

```
lib/src/shared/widgets/cards.dart : 98-113
    ClipRRect / ClipOval
      └── BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10))
            └── Container(decoration: BoxDecoration(...))
```

وكل هذه المكوّنات تمر من هنا:

| المكوّن | الملف | عدد الـ Blur لكل نسخة |
| :--- | :--- | :--- |
| `CircleButton` | `buttons.dart:82` | 1 |
| `AppButton` (نمط `glass` — **وهو النمط الافتراضي**) | `buttons.dart:345` | 1 |
| `AppTextField` (عندما `useGlass: true` — **وهو الافتراضي**) | `inputs.dart:579` | 1 لكل حقل |
| `AppSlidingTabs` | `tabs.dart:88` | 1 |
| `FrostedAppBar` (بطاقة العنوان) | `app_bar.dart:99` | 1 + زر الرجوع + كل `circleButton` في `actions` |
| `FrostedNavigationButtomBar` | `navigation_bar.dart:52` | 1 (بـ `sigma: 20`) + الـ FAB |
| `FrostedListSection` | `list_tile.dart:58` | 1 لكل قسم (✅ جيد — مشترك بين كل الـ tiles) |
| `AppBottomSheet` | `bottom_sheet.dart:67` | 1 |
| `AppDialog` / `showAppLoadingDialog` | `dialogs.dart:24, 416` | 1 |

### 2.2 لماذا `BackdropFilter` مكلف تحديداً؟

على مستوى الـ GPU، كل `BackdropFilter` يفرض:

1. **قراءة الخلفية (backdrop read):** يجب قراءة ما تم رسمه خلف الويدجت من الـ render target إلى نسيج (texture) منفصل.
2. **كسر مسار الـ tile:** كل وحدات GPU في الموبايل هي **Tile-Based Deferred Rendering** (Adreno / Mali / PowerVR / Apple GPU). القراءة من الـ framebuffer في منتصف التمرير تجبر الـ GPU على **إنهاء الـ render pass الحالي وكتابته للذاكرة، ثم بدء pass جديد**. هذه أغلى عملية منفردة في التحليل كله.
3. **تمريرتا ضبابية:** Gaussian blur على Impeller يُنفَّذ بتمريرتين قابلتين للفصل (أفقي + عمودي) على دقّة مصغّرة.

> توثيق Flutter الرسمي يقول حرفياً عن `BackdropFilter`:
> *"This effect is relatively expensive, especially if the filter is non-local, such as a blur."*
> وهناك تقارير مفتوحة معروفة: [flutter#32804](https://github.com/flutter/flutter/issues/32804) و [flutter#126353](https://github.com/flutter/flutter/issues/126353).

**النتيجة:** الكلفة ≈ `عدد الـ BackdropFilters × (كسر render pass + تمريرات الضبابية)`.
الكلفة **تتضاعف عددياً** ولا تُدمج تلقائياً — وهذا بالضبط ما تفعله الحزمة حالياً.

---

## 3. عدّ الطبقات الضبابية لكل شاشة (قياس فعلي من الكود)

### شاشة التسجيل `RegisterFormWidget` + `AuthScreen`

| العنصر | العدد |
| :--- | :--- |
| `nameField` + `emailField` + `passwordField` ×2 | 4 |
| `appSlidingTabs` | 1 |
| `appButton` (register — نمط glass افتراضي) | 1 |
| `FrostedAppBar` (عنوان + زر رجوع) | 2 |
| **المجموع** | **8 عمليات Backdrop Blur في إطار واحد** |

### شاشة تطبيقية نموذجية (Dashboard)

| العنصر | العدد |
| :--- | :--- |
| `FrostedAppBar`: زر رجوع + عنوان + زرَّا actions | 4 |
| `FrostedNavigationButtomBar` + FAB | 2 |
| `FrostedListSection` ×3 | 3 |
| `appButton` زجاجي ×2 | 2 |
| **المجموع** | **11 عملية Backdrop Blur في إطار واحد** |

> **القاعدة العملية المتعارف عليها في Flutter: لا تتجاوز 2–3 عمليات `BackdropFilter` مرئية في نفس الوقت.** الحزمة حالياً تتجاوز هذا الحد بـ 3–4 أضعاف بشكل افتراضي، بدون أن يشعر المطوّر المستخدم لها.

---

## 4. متى تُدفع الكلفة؟ — محفّزات إعادة الرسم (الأخطر)

الضبابية **لا تُدفع مرة واحدة**. تُدفع في **كل إطار** تحتاج فيه المنطقة لإعادة رسم. وهنا المشاكل الحقيقية:

### 🔴 4.1 التمرير خلف الـ AppBar والـ NavBar — `base_widget.dart:53-77`

```dart
body: Stack(
  children: [
    child,                                   // ← المحتوى القابل للتمرير
    if (bottomNavigationBar != null)
      Positioned(bottom: 0, ... ),           // ← زجاج فوقه
    if (!isHideAppbar && appbar == null)
      Positioned(top: 0, ... FrostedAppBar), // ← زجاج فوقه
  ],
),
```

`BaseWidget` يضع الـ AppBar والـ NavBar **فوق** المحتوى المتمرّر في `Stack`. هذا هو المظهر الزجاجي المطلوب — لكنه يعني أنّ **المحتوى خلف الزجاج يتغيّر في كل إطار أثناء التمرير، فيُعاد حساب الضبابية 60 أو 120 مرة في الثانية.**

هذا أغلى وضع تشغيل في الحزمة كاملة، وهو الوضع الافتراضي لكل شاشة.

### 🔴 4.2 أنيميشن داخل الطبقة المضببة — `navigation_bar.dart:170-240`

```dart
BlurredCard(sigmaX: 20, sigmaY: 20,       // ← الضبابية هنا (وبقيمة 20!)
  child: Row(children: [
    _FrostedNavbarItemWidget(...)          // ← وداخلها:
      // Transform.scale (AnimationController 100ms)
      // AnimatedContainer (250ms)
      // TweenAnimationBuilder<Color> (250ms)
  ]),
)
```

كل الأنيميشن **أبناء** للـ `BackdropFilter`. أي لمسة على تبويب = 250ms من إعادة الرسم داخل طبقة مضببة بـ `sigma: 20`. هذا خطأ معماري، وليس مجرد ضبط.

نفس النمط في `tabs.dart:99-116`: `AnimatedAlign` + `AnimatedDefaultTextStyle` داخل `bluredCard`.

### 🔴 4.3 Lottie داخل الزجاج — الأسوأ في المكتبة

`loading_button.dart:181` و `dialogs.dart:399`:

```dart
appButton(... style: glass ...,           // ← BackdropFilter
  child: AnimatedSwitcher(
    child: AppLoadingIndicator(size: 48), // ← Lottie، رسم متجهي 60fps
  ),
)
```

سبينر Lottie يُعيد رسم نفسه في كل إطار، **داخل** طبقة مضببة. يعني الضبابية تُعاد طوال مدة التحميل بالكامل، بشكل متواصل. نفس المشكلة في `showAppLoadingDialog` لكن على مساحة أكبر (ديالوغ).

### 🟡 4.4 الكتابة في حقول النص — `inputs.dart:579`

`AppTextField` يلفّ `CupertinoTextField` داخل `BlurredCard`. مؤشّر الكتابة (caret) يومض مرتين في الثانية → إعادة رسم → إعادة حساب الضبابية. وكل ضغطة زر كذلك. الحقل المركَّز فقط هو الذي يُعاد رسمه، لكن الضبابية تُعاد مع كل وميض.

### 🟡 4.5 غياب `RepaintBoundary` بالكامل

بحث في كامل `lib/`: **صفر استخدام لـ `RepaintBoundary`**. إعادة الرسم تنتشر أوسع من اللازم.

---

## 5. الذاكرة و GPU

### 5.1 لا يوجد تسريب ذاكرة ✅

الفحص أظهر:
- `_FrostedNavbarItemWidgetState._scaleController` → `dispose()` موجود ✅
- `FrostedNavbarController` (ValueNotifier) → التوثيق يطلب `dispose()` من المستخدم ✅
- `FrostedStepperController` → `dispose()` موثّق ✅
- `AppLogger` يطبع فقط داخل `kDebugMode` ✅ (لا كلفة في الإصدار النهائي)

### 5.2 ذاكرة GPU المؤقتة

كل `BackdropFilter` يحتاج render target بحجم حدوده + أنسجة وسيطة للضبابية المصغّرة.

الصيغة التقريبية (RGBA8888):
```
البايتات ≈ العرض(dp) × الارتفاع(dp) × DPR² × 4
```

على جهاز بـ DPR = 3 (تقدير):

| العنصر | الأبعاد (dp) | تقدير النسيج |
| :--- | :--- | :--- |
| شريط التنقل السفلي | 360 × 80 | ≈ 1.04 MB |
| بطاقة عنوان الـ AppBar | 250 × 48 | ≈ 0.41 MB |
| حقل نص واحد | 328 × 52 | ≈ 0.48 MB |
| زر دائري | 48 × 48 | ≈ 0.08 MB |

**الإجمالي التقريبي على شاشة مزدحمة: 3–6 MB لكل إطار** (تخصيص مؤقت، يُعاد تدويره — ليس تسريباً).

المشكلة ليست الحجم، بل **عرض النطاق (bandwidth)**: كتابة وقراءة هذه الأنسجة 60 مرة في الثانية على GPU متوسط يستهلك ذاكرة ويولّد حرارة.

---

## 6. الكلفة على CPU / Dart (منخفضة نسبياً)

| الملاحظة | الموقع | الأثر |
| :--- | :--- | :--- |
| `AppThemes.border(context)` يُنشئ كائن `Border` جديد في كل `build` | `cards.dart:83` | ضئيل، لكنه متكرر جداً |
| دوال الـ mixins (`blurredCard`, `appButton`…) تمنع استخدام `const` على الويدجتات | كل الـ mixins | يمنع تخزين الويدجت مؤقتاً، يوسّع نطاق الـ rebuild |
| `List.generate` داخل `build` | `tabs.dart:126`, `navigation_bar.dart:66` | إعادة بناء كل العناصر عند أي rebuild للأب |
| `Navigator.of(context).canPop()` داخل `build` | `app_bar.dart:70` | يُنشئ تبعية على الـ Navigator → إعادة بناء عند تغيير المسار |
| `clipBehavior: Clip.antiAlias` (وليس `antiAliasWithSaveLayer`) | `cards.dart:27` | ✅ اختيار صحيح — تجنّب `saveLayer` إضافي |

**هذه البنود ثانوية.** إصلاحها لن يُحدث فرقاً ملموساً قبل إصلاح مشكلة الـ `BackdropFilter`.

---

## 7. حجم التطبيق والاعتماديات

### 7.1 `lottie` مقابل ملف 3 KB 🔴

```yaml
lottie: ^3.5.1   # يجرّ معه: archive, http
```

الاستخدام الوحيد: `assets/lottie/loading.json` — **حجمه 3072 بايت**.

`lottie` مكتبة كاملة لعرض ملفات After Effects (تحليل JSON، أشكال، أقنعة، تعبيرات، مسارات). كل تطبيق يستخدم `frosted_ui_kit` يدفع ثمنها في حجم الـ APK/IPA، حتى لو لم يعرض سبينراً أبداً. وتجرّ معها `archive` (لملفات dotLottie) و `http` (للتحميل من الشبكة) — وكلاهما غير مستخدم هنا.

### 7.2 قيود `any` 🟡

```yaml
material_ui: any
cupertino_ui: any
```

`any` يعني أن أي إصدار جديد كاسر (breaking) من هاتين الحزمتين سيكسر بناء كل من يستخدم `frosted_ui_kit`. وهذا أيضاً يخفّض تقييم الحزمة على pub.dev. يجب تثبيتها بـ `^x.y.z`.

### 7.3 كود تجريبي منشور داخل المكتبة 🟡

`lib/main.dart` و `lib/src/features/home/persentation/screen/home.dart` هما تطبيق تجريبي داخل مكتبة منشورة. الـ tree-shaking في AOT يحذفهما فلا أثر وقت التشغيل، لكنهما وزن زائد في الحزمة. (ولاحظ الخطأ الإملائي: `persentation` بدل `presentation`.)

---

## 8. جدول الأولويات

| # | المشكلة | الأثر | جهد الإصلاح | كسر التوافق |
| :-: | :--- | :-: | :-: | :-: |
| 1 | كل `BlurredCard` = `BackdropFilter` مستقل | 🔴 عالٍ جداً | منخفض | لا |
| 2 | الأنيميشن داخل الطبقة المضببة (navbar + tabs) | 🔴 عالٍ | متوسط | لا |
| 3 | Lottie داخل الزجاج (loading button + dialog) | 🔴 عالٍ | منخفض | لا |
| 4 | لا يوجد مفتاح لإيقاف الزجاج على الأجهزة الضعيفة | 🔴 عالٍ | منخفض | لا |
| 5 | `sigma: 20` في شريط التنقل | 🟡 متوسط | تافه | لا |
| 6 | `useGlass: true` افتراضياً في حقول النص | 🟡 متوسط | تافه | نعم (v2) |
| 7 | `AppButtonStyle.glass` هو النمط الافتراضي | 🟡 متوسط | تافه | نعم (v2) |
| 8 | غياب `RepaintBoundary` | 🟡 متوسط | منخفض | لا |
| 9 | `lottie` كاعتمادية إلزامية | 🟡 متوسط | متوسط | نعم (v2) |
| 10 | `material_ui: any` / `cupertino_ui: any` | 🟢 منخفض | تافه | لا |
| 11 | `lib/main.dart` + `features/home` داخل الحزمة | 🟢 منخفض | تافه | لا |

---

## 9. التحسينات المقترحة — مع الكود

### ⭐ 9.1 التحسين الأهم: `BackdropGroup` + `BackdropFilter.grouped`

Flutter 3.29 أضاف حلاً مصمَّماً **تحديداً** لحالة هذه الحزمة:

> *"Applications that display multiple backdrop filters can now use the new widget `BackdropGroup` and a new `BackdropFilter.grouped` constructor. These can improve performance of multiple blurs above and beyond what was possible on the Skia backend."*
> — [What's new in Flutter 3.29](https://flutter.dev/blog/whats-new-in-flutter-3-29)

بدل أن يقرأ كل فلتر الخلفية بنفسه، **كل الفلاتر داخل `BackdropGroup` تتشارك نسيج خلفية واحد**. من N قراءة خلفية إلى قراءة واحدة. كلما زاد N زاد الربح — وهذه بالضبط حالة الحزمة (N = 8 إلى 11).

`pubspec.lock` يُظهر `flutter: ">=3.44.0"` — يعني الـ API متوفّر بدون أي شرط.

**التعديل في `cards.dart`:**

```dart
class BlurredCard extends StatelessWidget {
  const BlurredCard({
    super.key,
    required this.child,
    // ... البقية كما هي
    this.enabled,          // null = تلقائي حسب FrostedPerformance
    this.grouped = true,   // يشارك الخلفية مع أقرب BackdropGroup
  });

  /// تعطيل الضبابية نهائياً لهذه البطاقة (يتخطّى الـ BackdropFilter كلياً).
  final bool? enabled;

  /// استخدام BackdropFilter.grouped لمشاركة طبقة الخلفية.
  final bool grouped;

  @override
  Widget build(BuildContext context) {
    final perf = FrostedPerformance.of(context);
    final sx = sigmaX * perf.blurScale;
    final sy = sigmaY * perf.blurScale;
    final blurOn = (enabled ?? perf.blurEnabled) && (sx > 0 || sy > 0);

    // عندما تُطفأ الضبابية نُبقي نفس الـ Container بالضبط،
    // فلا يتغيّر التخطيط ولا يحصل layout shift.
    final containerWidget = Container(/* ... كما هو ... */);

    Widget wrap(Widget inner) {
      if (!blurOn) return inner;
      final filter = ImageFilter.blur(sigmaX: sx, sigmaY: sy);
      return grouped
          ? BackdropFilter.grouped(filter: filter, child: inner)
          : BackdropFilter(filter: filter, child: inner);
    }

    if (shape == BoxShape.circle) {
      return ClipOval(clipBehavior: clipBehavior, child: wrap(containerWidget));
    }
    return ClipRRect(
      borderRadius: effectiveBorderRadius ?? BorderRadius.zero,
      clipBehavior: clipBehavior,
      child: wrap(containerWidget),
    );
  }
}
```

**وفي `base_widget.dart` — نلفّ الشاشة كلها:**

```dart
@override
Widget build(BuildContext context) {
  return BackdropGroup(          // ← سطر واحد، يستفيد منه كل زجاج الشاشة
    child: Scaffold(
      extendBody: bottomNavigationBar != null,
      // ... البقية كما هي
    ),
  );
}
```

> ⚠️ ملاحظة: `BackdropFilter.grouped` يبحث عن أقرب `BackdropGroup` في الشجرة. المكوّنات التي تُعرض خارج شجرة الشاشة (`showAppBottomSheet`، `showAppDialog`) تُبنى في الـ `Navigator` overlay، لذلك تحتاج `BackdropGroup` خاصاً بها داخل الـ builder، أو تُترك بـ `grouped: false`.

---

### ⭐ 9.2 مفتاح أداء عام — `FrostedPerformance`

هذا **ليس تحسيناً تجميلياً، بل شرط لتشغيل الحزمة على أجهزة السوق المتوسطة.**

ملف جديد `lib/src/utils/frosted_performance.dart`:

```dart
import 'package:material_ui/material_ui.dart';

/// مفتاح عام يتحكّم بكل الأسطح الزجاجية في `frosted_ui_kit`.
///
/// ضعه فوق `MaterialApp` لتخفيض أو إطفاء الضبابية على الأجهزة الضعيفة،
/// أو عند تفعيل "تقليل الحركة" في إعدادات الوصولية.
class FrostedPerformance extends InheritedWidget {
  const FrostedPerformance({
    super.key,
    this.blurEnabled = true,
    this.blurScale = 1.0,
    this.fallbackOpacity = 0.88,
    required super.child,
  }) : assert(blurScale >= 0.0 && blurScale <= 1.0);

  /// إطفاء كل عمليات BackdropFilter (أعلى ربح أداء ممكن).
  final bool blurEnabled;

  /// معامل ضرب لكل قيم sigma (0.0 – 1.0).
  final double blurScale;

  /// شفافية التعبئة البديلة عندما تكون الضبابية مُطفأة.
  final double fallbackOpacity;

  static const _fallback = _Defaults();

  static FrostedPerformanceData of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<FrostedPerformance>();
    if (w == null) return const FrostedPerformanceData();
    return FrostedPerformanceData(
      blurEnabled: w.blurEnabled,
      blurScale: w.blurScale,
      fallbackOpacity: w.fallbackOpacity,
    );
  }

  @override
  bool updateShouldNotify(FrostedPerformance old) =>
      blurEnabled != old.blurEnabled ||
      blurScale != old.blurScale ||
      fallbackOpacity != old.fallbackOpacity;
}

class FrostedPerformanceData {
  const FrostedPerformanceData({
    this.blurEnabled = true,
    this.blurScale = 1.0,
    this.fallbackOpacity = 0.88,
  });
  final bool blurEnabled;
  final double blurScale;
  final double fallbackOpacity;
}
```

**الاستخدام:**

```dart
// ربطه بإعداد الوصولية "تقليل الحركة" + إعداد يدوي للمستخدم
FrostedPerformance(
  blurEnabled: !MediaQuery.disableAnimationsOf(context) && !userPrefersLiteMode,
  blurScale: isLowEndDevice ? 0.5 : 1.0,
  child: MaterialApp(...),
)
```

مع هذا المفتاح، أي تطبيق (مثلاً تطبيق صيدلية على جهاز Android متوسط) يستطيع تقديم **وضع خفيف** بسطر واحد، بنفس التخطيط تماماً وبدون أي `layout shift`.

---

### ⭐ 9.3 إخراج الأنيميشن من داخل الطبقة المضببة

**هذا أكبر مكسب بنيوي بعد `BackdropGroup`.**

المبدأ: اجعل اللوح الزجاجي **طبقة خلفية ساكنة**، وارسم المحتوى المتحرّك **فوقه كشقيق (sibling)** وليس كابن.

**`navigation_bar.dart` — قبل:**
```dart
BlurredCard(sigmaX: 20, sigmaY: 20,
  child: Row(children: [ /* عناصر متحركة */ ]),   // ❌ داخل الفلتر
)
```

**بعد:**
```dart
SizedBox(
  height: 72,
  child: Stack(
    children: [
      // طبقة الزجاج — لا يتحرّك أي شيء داخلها إطلاقاً
      Positioned.fill(
        child: RepaintBoundary(
          child: BlurredCard(
            borderRadius: BorderRadius.circular(32),
            sigmaX: 12, sigmaY: 12,      // ← خُفّضت من 20
            border: Border.all(/* ... */),
            child: const SizedBox.expand(),
          ),
        ),
      ),
      // المحتوى المتحرّك — خارج شجرة الـ BackdropFilter
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(widget.items.length, (i) =>
            _FrostedNavbarItemWidget(
              item: widget.items[i], index: i, controller: widget.controller,
            ),
          ),
        ),
      ),
    ],
  ),
)
```

النتيجة: أنيميشن اللمس الآن يُعيد رسم **بكسلات فوق** الزجاج فقط، ولا يُجبر إعادة حساب الضبابية.

**نفس النمط يُطبَّق على `tabs.dart`:** الـ `AnimatedAlign` (حبّة المؤشّر المنزلقة) و `AnimatedDefaultTextStyle` يُرفعان فوق لوح زجاجي ساكن.

---

### ⭐ 9.4 إصلاح Lottie داخل الزجاج

ثلاثة خيارات، مرتّبة من الأبسط للأفضل:

**(أ) إطفاء الضبابية أثناء التحميل — `loading_button.dart`:**
```dart
appButton(
  context: context,
  style: state == FrostLoadingButtonState.loading
      ? AppButtonStyle.colored   // ← بلا BackdropFilter أثناء الأنيميشن
      : style,
  // ...
)
```

**(ب) رسم السبينر فوق الزجاج بدل داخله** (نفس نمط 9.3).

**(ج) الأفضل — جعل `lottie` اختيارية:**
```dart
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.size = 64.0, this.color, this.builder});

  /// باني مخصّص للمؤشّر. عند تركه فارغاً يُستخدم مؤشّر خفيف مرسوم بـ CustomPainter.
  final WidgetBuilder? builder;
  // ...
}
```
مع نقل نسخة Lottie إلى حزمة مرافقة `frosted_ui_kit_lottie`. هذا يحذف `lottie` + `archive` + `http` من كل مستهلكي الحزمة.

---

### 9.5 تحسينات متوسطة

**خفض قيم sigma الافتراضية:**
```dart
// cards.dart — الافتراضي الحالي 10.0، معقول
this.sigmaX = 10.0,
this.sigmaY = 10.0,

// navigation_bar.dart — 20 مبالغ فيه
sigmaX: 12, sigmaY: 12,   // بدل 20
```

**تخزين الـ Border مؤقتاً — `app_themes.dart`:**
```dart
// بدل إنشاء Border جديد في كل build
static final Map<Color, Border> _borderCache = {};
static Border border(BuildContext context) {
  final c = borderColor(context);
  return _borderCache.putIfAbsent(c, () => Border.all(color: c));
}
```

**إضافة `RepaintBoundary`** حول شريط التنقل وشريط العنوان في `base_widget.dart`.

**تثبيت الاعتماديات — `pubspec.yaml`:**
```yaml
material_ui: ^<الإصدار_الفعلي>      # بدل any
cupertino_ui: ^<الإصدار_الفعلي>     # بدل any
```

**حذف الكود التجريبي:** انقل `lib/main.dart` و `lib/src/features/home/` إلى `example/`.

---

### 9.6 تغييرات مقترحة لـ v2.0 (كاسرة للتوافق)

| التغيير | السبب |
| :--- | :--- |
| `AppButtonStyle.colored` كنمط افتراضي بدل `glass` | كل زر يُكتب بدون تحديد نمط يحصل على `BackdropFilter` صامت |
| `AppTextField.useGlass = false` افتراضياً | النماذج عادة فوق سطح معتم — الضبابية غير مرئية أصلاً وتُدفع كلفتها |
| `lottie` كاعتمادية اختيارية | حجم الحزمة |

---

### 9.7 قاعدة توثيقية مقترحة لـ `FROSTED_UI_KIT.md`

> **قاعدة الميزانية الزجاجية:** الزجاج مخصّص للأسطح التي تطفو **فوق صور أو تدرّجات لونية**. فوق سطح معتم، الضبابية تُكلّف بدون أن تُرى.
> **لا تتجاوز 3 أسطح زجاجية مرئية في نفس الوقت في الشاشة الواحدة.** استخدم `FrostedListSection` (ضبابية واحدة مشتركة) بدل بطاقات زجاجية متعدّدة، واستخدم `AppButtonStyle.colored` للأزرار الثانوية.

---

## 10. خطة القياس (للتحقق قبل وبعد)

```bash
# 1. تشغيل في وضع profile على جهاز حقيقي (وليس محاكي)
flutter run --profile

# 2. في DevTools → Performance:
#    راقب سطر "Raster" تحديداً (وليس "UI").
#    إذا كان Raster > 8ms فالمشكلة GPU-bound → أي مشكلة BackdropFilter.

# 3. طبقة الأداء المرئية على الجهاز
flutter run --profile --dart-define=...   # ثم فعّل PerformanceOverlay

# 4. تتبّع تفصيلي لعمليات الرسم
flutter run --profile --trace-skia

# 5. تحليل حجم الحزمة (لقياس أثر إزالة lottie)
flutter build apk --analyze-size --target-platform android-arm64
```

**اختبار A/B سريع بعد تطبيق 9.2:**
بدّل `blurEnabled` بين `true` و `false` وقارن سطر الـ Raster. الفرق بينهما هو **الكلفة الحقيقية للزجاج على ذلك الجهاز بالضبط** — وهذا أدقّ بكثير من أي تقدير نظري في هذا التقرير.

**أجهزة الاختبار المقترحة:**
- جهاز مرجعي منخفض: Android بـ Snapdragon 4xx / Mali-G52 (يمثّل شريحة واسعة من مستخدمي السوق العراقي)
- جهاز مرجعي متوسط: Snapdragon 6xx/7xx
- iPhone حديث كمرجع أعلى

---

## 11. الحكم النهائي

| السؤال | الجواب |
| :--- | :--- |
| **هل تزيد استهلاك الموارد؟** | نعم — بشكل ملموس، والزيادة على **GPU/raster**، وليست على RAM أو CPU |
| **هل هناك تسريب ذاكرة؟** | لا. التخلّص من الـ controllers سليم وموثّق |
| **هل تصلح للإنتاج كما هي؟** | على الأجهزة الراقية: نعم. على الأجهزة المتوسطة والضعيفة: ليس بالإعدادات الافتراضية الحالية |
| **هل المشكلة قابلة للإصلاح؟** | نعم، وبشكل مركزي — أغلب الربح يأتي من `cards.dart` + `base_widget.dart` + `navigation_bar.dart` |

### خارطة طريق مقترحة

**المرحلة 1 — لا تكسر التوافق، أعلى ربح (يوم عمل تقريباً):**
1. `BackdropGroup` + `BackdropFilter.grouped` (بند 9.1)
2. `FrostedPerformance` وضع الأداء العام (بند 9.2)
3. إطفاء ضبابية زر التحميل أثناء الـ loading (بند 9.4-أ)
4. خفض sigma شريط التنقل من 20 إلى 12

**المرحلة 2 — إعادة هيكلة موضعية (2–3 أيام):**
5. إخراج أنيميشن شريط التنقل والتبويبات من داخل الطبقة المضببة (بند 9.3)
6. `RepaintBoundary` + تخزين الـ Border مؤقتاً
7. تثبيت `material_ui` و `cupertino_ui`، ونقل الكود التجريبي إلى `example/`

**المرحلة 3 — v2.0:**
8. تغيير الأنماط الافتراضية (`colored` للأزرار، `useGlass: false` للحقول)
9. فصل `lottie` إلى حزمة مرافقة
10. توثيق "قاعدة الميزانية الزجاجية" في الدليل الرسمي

---

## المصادر

- [BackdropFilter class — Flutter API](https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html)
- [BackdropGroup class — Flutter API](https://api.flutter.dev/flutter/widgets/BackdropGroup-class.html)
- [BackdropFilter.grouped constructor — Flutter API](https://api.flutter.dev/flutter/widgets/BackdropFilter/BackdropFilter.grouped.html)
- [What's new in Flutter 3.29 — Flutter Blog](https://flutter.dev/blog/whats-new-in-flutter-3-29)
- [flutter#32804 — BackdropFilter performance issue](https://github.com/flutter/flutter/issues/32804)
- [flutter#126353 — Impeller Blur BackdropFilter performance degradation](https://github.com/flutter/flutter/issues/126353)
