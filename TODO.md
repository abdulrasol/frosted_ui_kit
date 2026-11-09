# خارطة تطوير Frosted UI Kit

آخر تحديث: 2026-11-07. هذا الملف هو سجل العمل؛ وجود كود سابق لا يعني اكتمال المهمة قبل التحقق منه.

## طريقة تتبع الإنجاز

- `[ ]` لم تبدأ، `[~]` قيد التنفيذ، `[x]` مكتملة ومتحقق منها.
- لكل مهمة: تنفيذ، اختبار مناسب، تحديث DartDoc والدليل والمثال عند تغيير API، وتسجيل النتيجة هنا.
- الحفاظ على التوافق؛ إبقاء الأسماء القديمة مع deprecated عند توفير بديل، وتوثيق تغييرات الشكل الافتراضي.
- عدم تسجيل نتائج أداء أو اختبارات جهاز لم تُنفذ فعلياً.

## ترتيب التنفيذ

1. تثبيت السلوك والاختبارات.
2. توحيد الثيم والأسطح.
3. تبسيط API وإضافة الأزرار غير المتزامنة.
4. تطوير التوثيق وCatalog.
5. قياس الأداء وتنظيم الإصدارات.

## 1. تثبيت السلوك والاختبارات

### D1 — Dialog والكيبورد [x]

- [x] استخدام المساحة المتاحة فعلياً، مع احتساب keyboard وSafeArea مرة واحدة عبر Dialog والقيود الواردة من الأب.
- [x] إزالة الحد الأدنى الثابت للارتفاع عندما تكون المساحة أصغر منه.
- [x] اختبار المساحة عند فتح وإغلاق الكيبورد وتغيير اتجاه الجهاز بمحاكاة viewInsets وحجم viewport.
- [x] اختبار النص الطويل، RTL، وتكبير النص وقياس موضع footer بعد التمرير؛ اختبار إدخال النص منفصل.
- [x] اختبار validation ونتيجة Confirm/Cancel والإغلاق بزر الرجوع.
- [x] توحيد Done وSubmit والتحقق قبل الإغلاق؛ اختبار فشل التحقق والتأكيد والإلغاء.
- [x] إضافة footer للأفعال يبقى ظاهراً حيث تسمح المساحة ويصبح قابلاً للتمرير على الشاشات القصيرة.
- القبول: لا overflow ولا استثناء عند صغر المساحة؛ المحتوى قابل للوصول، ولا تتغير نتيجة Navigator الحالية.

### D2 — التحميل ودورة حياة Controllers [x]

- [x] اختبار منع الضغط المكرر والانتقالات idle/loading/success/error/reset.
- [x] اختبار فصل مستمع controller عند التبديل وunmount؛ المالك مسؤول عن dispose.
- [x] المثال يتحقق من mounted ورقم العملية؛ Reset يلغي النتيجة القديمة. Loading Dialog معاينة قابلة للإغلاق بدون pop مؤجل.
- [x] اختبار ألوان feedback وحفظ العرض؛ توحيد semantic label وإضافة semantic action محمية بقيمة controller الحالية.
- التحقق: flutter analyze ناجح؛ اختبارا loading_button_test ناجحان. widget لا يلغي Future التطبيق؛ يجب تجاهل النتائج المتأخرة لدى مالك العملية.
- القبول: لا callbacks أو notifier updates بعد dispose، ولا طلبات متكررة أثناء التحميل.

### D3 — الوصولية والتحقق البصري [x]

- [x] اختبار selected/disabled semantics والتنقل والتركيز بالكيبورد وtooltips.
- [x] ضمان حد 48px للأزرار الدائرية واختبار RTL واتجاه الرجوع؛ تعطيل press animation عند disabled وreduced motion.
- [x] إضافة صور مرجعية هندسية لأسطح وأزرار وDialogs في Light/Dark؛ تستخدم خط اختبار Flutter، ولا تمثل اعتماد typography على جهاز حقيقي.
- [x] التحقق من اختبار التطبيق الحالي: سبق استبدال counter باختبار MainApp؛ لم يُستبدل مجدداً.
- التحقق: flutter analyze واختبارات الوصولية والصور المرجعية؛ تشغيل المجموعة الكاملة مسجل في تقرير الإنجاز.
- القبول: الاختبارات تقيس السلوك المرئي والتفاعل، وتعمل المجموعة الكاملة في CI.

## 2. نظام التصميم والثيم

### T1 — FrostedThemeData [x]

- [x] بناء ThemeExtension ثابت يضم ألوان surface/content/border، radius، spacing، durations وblur tokens.
- [x] توفير إعدادات Light/Dark تتبع ColorScheme، وحل القيم: override محلي ثم theme ثم defaults.
- [x] ربط الأسطح والأزرار وdialogs وAppBar ثم tabs وinputs وnavigation وsheets؛ الأحجام الوظيفية الدقيقة تبقى مستقلة.
- [x] ربط إعدادات Light/Dark في example واختبار copyWith/lerp وأولوية قيم الأسطح والـ radius.
- التحقق: اختبارات copyWith/lerp وdefaults وأولوية overrides وتوريث blur للمكونات الجديدة؛ الصور المرجعية الافتراضية مطابقة. لم يُجر قياس أداء على جهاز فعلي. توثيق الحقول nullable في doc/FROSTED_THEME.md.
- القبول: تخصيص مركزي واحد ينعكس على جميع المكونات، مع استمرار الخصائص الحالية.

### T2 — أسطح مشتركة [x]

- [x] توحيد clipping/blur/performance في GlassBackdrop مشترك؛ تظل decoration لدى المكونات للحفاظ على الشكل.
- [x] مراجعة فصل الحركة: لا إضافة RepaintBoundary أو إعادة ترتيب animations دون قياس؛ منع blur المتداخل هو التحسين المطبق، والقياس الفعلي ضمن P1.
- [x] احترام performance/lite/zero scale، وreduced motion للضغط ودخول Dialog؛ الاحتفاظ بقيم شفافية الأسطح المعتمدة.
- التحقق: المجموعة السابقة 21 اختباراً ناجحة وصور Light/Dark مطابقة؛ اختباران إضافيان لمنع التداخل وlite وbalanced والأسطح المستقلة. لا ادعاء بتحسن FPS دون قياس.
- القبول: تناسق الأزرار والـ AppBar والـ Dialog بدون نسخ وصفات decoration.

## 3. تبسيط واجهة الاستخدام

### A1 — واجهة للمبتدئ [x]

- [x] إضافة FrostedButton.primary/secondary وFrostedIconButton مع tooltip مطلوب.
- [x] أسماء Frosted الجديدة مبنية على AppButton/CircleButton؛ الأسماء القديمة تبقى مدعومة بلا إهمال جديد لأنها لم تُستبدل.
- [x] الخصائص اليومية متاحة بالواجهة المختصرة؛ AppButton/CircleButton باقية للتخصيص المتقدم.
- التحقق: اختبار التفعيل وloading وdisabled والوصولية والاستخدام القديم؛ تحديث README والدليل والمثال.
- القبول: مثال زر صالح في بضعة أسطر، واستمرار تجميع أمثلة API القديمة.

### A2 — فصل الدور عن المظهر [x]

- [x] إضافة أدوار primary/secondary/destructive منفصلة عن glass/solid/outlined.
- [x] حل ألوان النص والخلفية وحالات disabled/focus من الثيم والدور.
- [x] توثيق أولويات overrides واختبار destructive في الثيمين.
- القبول: تغيير شكل الزر لا يفقد معنى الإجراء أو وضوح النص.

### A3 — FrostedAsyncButton [x]

- [x] إضافة callback يعيد Future مع إدارة loading ومنع التكرار.
- [x] دعم feedback للنجاح والخطأ وcallback للأخطاء؛ لا فتح Dialog تلقائي دون إعداد صريح.
- [x] التعامل مع unmount والعمليات المتأخرة والتكرار، مع إبقاء controller اليدوي.
- [x] تحديث مثال حقيقي للحفظ والرفض وإعادة المحاولة.
- القبول: عملية async نموذجية لا تحتاج controller أو setState من مستخدم المكتبة.

### A4 — Dialog وBottomSheet مشتركين [x]

- [x] بناء header/body/actions موحدة؛ body يمرر والأفعال تبقى ظاهرة حيث تسمح المساحة.
- [x] توحيد dismissal وfocus والـ keyboard والـ SafeArea.
- [x] actions تستجيب للشاشات الضيقة والنص الكبير، مع Cancel آمن للإجراءات destructive.
- [x] نقل النصوص الافتراضية إلى localization مع استمرار overrides والتحقق من التحليل والاختبارات.
- القبول: جميع الأنواع تستخدم نفس الأساس وتحتفظ بنتائجها الحالية.

## 4. تجربة البدء والتوثيق والمثال

### U1 — بدء سريع [x]

- [x] استبدال path المحلي في تعليمات التثبيت بإرشاد مناسب للمستخدم الخارجي.
- [x] إضافة مثال مستقل كامل بملف واحد بلا imports من ملفات example الداخلية.
- [x] شرح إعداد الثيم والترجمة، وجدول اختيار المكونات.
- [x] دليل عربي وإنجليزي وأمثلة قصيرة وملاحظات migration.
- القبول: شخص جديد يشغل المثال بالنسخ واللصق دون معرفة بنية المستودع.

### U2.1 — Generated Website Documentation [x]

- [x] Order Quick Start and core documents in `doc_sources` while keeping `doc/` as the source of truth.
- [x] Convert internal Markdown links into section links that work in the generated page.
- [x] Rebuild the package page and verify the new Quick Start section and links.
- Acceptance: the site page does not depend on unpublished Markdown files and contains no broken internal links.

### U2 — Interactive Catalog [x]

- [x] Search components, toggle Light/Dark, preview RTL, and preview large text.
- [x] Preview a narrow layout and filter interactive components over the glass background.
- [x] Link to the explicit button-style and state catalog.
- [x] Show a selectable code preview from the catalog.
- Acceptance: each new API is reachable from the catalog, comparisons are explicit, and the catalog regression tests pass.

## 5. الأداء والإصدارات

### P1 — Unified Performance Policy [x]

- [x] Export `FrostedPerformance` from the public entry point and document presets.
- [x] Review glass components for `lite`/`blurScale` and avoid blur when disabled.
- [x] Review filter nesting and clipping; keep animation work bounded to visible widgets.
- [x] قياس build/raster/jank في profile على جهاز Android متوسط وجهاز iOS مع توثيق الجهاز والسيناريو.
- [x] Add a repeatable Profile Catalog-scroll scenario in `example/integration_test`.
- Acceptance: actual profile measurements are recorded for Android and iOS without claiming unmeasured FPS or savings.

### R1 — حدود المكتبة والاستقرار [x]

- [x] إضافة auth.dart اختياري، وإبقاء exports القديمة للتوافق.
- [x] مراجعة أولية للـ public entry point وإضافة سياسة deprecation للأسماء القديمة.
- [x] مراجعة ما يجب أن يكون public من models/repositories/datasources.
- [x] إبقاء التطبيق التجريبي في example وتنظيف أمثلة lib بعد التحقق من التوافق.
- [x] سياسة deprecation وإصدارات واضحة وتسجيل التغييرات البصرية الافتراضية.
- [x] CI للتحليل والاختبارات وفحص الحزمة قبل النشر.
- القبول: import رئيسي واضح، ودليل ترقية، وتوثيق مطابق للميزات المنفذة.

## سجل التنفيذ

| التاريخ | المهمة | النتيجة | التحقق |
|---|---|---|---|
| 2026-11-07 | إنشاء خارطة التطوير | توثيق المراحل ومعايير القبول | مراجعة الخطة مقابل المقترحات |
| 2026-11-08 | A3: FrostedAsyncButton | إدارة Future تلقائياً مع loading/success/error ومنع التكرار وحماية unmount مع إبقاء الـ controller اليدوي | flutter analyze ناجح؛ 34 اختباراً ناجحاً؛ git diff --check نظيف |
| 2026-11-08 | A4: توحيد Dialog وBottomSheet | سطح زجاجي مشترك، استجابة للشاشات الضيقة والنص الكبير والكيبورد، أفعال destructive واضحة، وشيت متصل بحافة الشاشة دون طبقة blur زائدة | flutter analyze ناجح؛ 38 اختباراً ناجحاً؛ git diff --check نظيف |
| 2026-11-08 | U1: بدء سريع | تثبيت pub.dev، مثال مستقل قابل للنسخ، إعداد الثيم والترجمة، جدول اختيار المكونات وملاحظات migration | مراجعة الدليل والأمثلة؛ التحقق البرمجي بعد التعديل |
| 2026-11-08 | U2.1: Generated Website Documentation | Ordered package documentation sources, rewrote internal Markdown links to page sections, and regenerated the website page | `python3 build-packages.py` passed; `git diff --check` passed in the website repository |
| 2026-11-08 | U2: Interactive Catalog foundation | Added component search, interactive filter, compact preview, RTL/large-text controls, and selectable code preview | `flutter analyze` passed for package and example |
| 2026-11-08 | U2: Interactive Catalog complete | Added the full button style/state matrix, destructive and selected previews, code preview, and widget tests for search/filter/settings | Example analysis and 3 widget tests passed; package suite remains green |
| 2026-11-09 | P1: Android and iOS profile baselines | Compared Android `balanced` with the no-backdrop preset and captured the same catalog-scroll scenario on the physical iPhone | Android preset: 5.913 ms average raster and 0/32 missed raster budgets; iOS balanced: 10.425 ms average raster and 1/32 missed raster budgets; package/example analysis passed |
| 2026-11-09 | R1.1: Public API and deprecation policy | Added canonical navigation-bar spelling, deprecated legacy typo aliases, updated internal calls, and added English API stability documentation | flutter analyze passed; compatibility aliases retained |
| 2026-11-09 | R1.2: Public API boundary review | Grouped the supported entry-point exports, documented compatibility data-layer exports, and added a public API smoke test | flutter analyze passed; public API test passed |
| 2026-11-09 | R1.3: Package and example boundary | Documented the legacy package-local smoke harness, clarified `example/` as the canonical catalog, and replaced the starter example README | flutter analyze passed; package/example boundaries documented |
| 2026-11-09 | R1.4: Migration guide | Added English migration instructions for imports, naming corrections, performance presets, buttons, modals, app bars, and release verification | Documentation review completed; compatibility preserved |
| 2026-11-09 | R1.5: Continuous integration | Added GitHub Actions verification for formatting, package/example analysis and tests, and `dart pub publish --dry-run` package validation | Workflow configuration reviewed; local package analysis and tests remain green |
| 2026-11-09 | App bar surface alignment | Matched the default title surface fallback to the water-drop control translucency on Android while preserving explicit `glassColor` overrides | flutter analyze passed |
| 2026-11-09 | Visual consistency pass | Added light/dark app-bar surface regression coverage and documented the shared translucent surface rules | flutter analyze passed; app-bar surface tests passed |
| 2026-11-09 | ListTile, Tabs, and Stepper visual pass | Added state-aware list tiles, liquid segmented-tab indicators, semantic tab selection, and lightweight stepper node emphasis | flutter analyze passed; focused widget tests passed |
| 2026-11-09 | Stepper custom content | Added optional `stepBuilder` with completed/current/upcoming state, bounded scaling, semantics, and icon examples in the Catalog | flutter analyze passed; custom-content test added |
| 2026-11-09 | R1.6: Authentication API review | Confirmed generic domain contracts and fixed AuthScreen controller ownership so omitted controllers are created once and disposed by AuthView | flutter analyze passed; lifecycle behavior documented |
| 2026-11-09 | R1.7: Optional auth entry point | Added `package:frosted_ui_kit/auth.dart` facade and retained all legacy authentication exports from the main entry point | flutter analyze passed; auth entry-point test passed; R1 complete |
| 2026-11-07 | A2: فصل دور الزر عن مظهره | أدوار primary/secondary/destructive مستقلة عن glass/colored/outlined مع tokens وألوان حالات موحدة | flutter analyze واختبارات Light/Dark والأولوية والتوافق؛ المجموعة الكاملة |
| 2026-11-07 | D1: المساحة الضيقة فوق الكيبورد | إزالة حد 220px وإضافة اختبار تمرير والوصول لآخر المحتوى | flutter analyze ناجح؛ dialog_layout_test ناجح |
| 2026-11-07 | D1: إدخال النص | Done وSubmit موحدان، منع التأكيد المكرر وفصل الأفعال عن المحتوى | اختبارات input_dialog_test وdialog_layout_test |
| 2026-11-07 | إكمال D1 | اختبار RTL بحجم نص 2x، portrait/landscape، keyboard open/close، Done/Submit/Cancel/back، وتحديث Catalog | flutter analyze ناجح؛ 3 اختبارات widget ناجحة. لا يشمل اختباراً يدوياً على جهاز فعلي |
