// import 'package:capsula_360/src/utils/app_colors.dart';
// import 'package:capsula_360/src/utils/app_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CheckoutStepper extends StatelessWidget {
//   const CheckoutStepper({super.key, required this.controller});
//   final CheckoutStepperController controller;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (context, child) {
//         final index = controller.index;
//         print(index);
//         return Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: _wdSteps(index));
//       },
//     );
//   }

//   List<Widget> _wdSteps(int index) {
//     List<Widget> list = [];
//     for (int i = 0; i < controller.steps; i++) {
//       list.add(_wdStep(i));
//       if (i < controller.steps - 1) {
//         list.add(_wdStepLine(i));
//       }
//     }
//     return list;
//   }

//   Widget _wdStep(int index) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: EdgeInsets.all(10.r),
//           decoration: BoxDecoration(color: index <= controller.index ? AppColors.main : AppColors.unDoneColor, shape: BoxShape.circle),
//           child: Text(
//             (index + 1).toString(),
//             style: AppTheme.titleTextStyle.copyWith(fontSize: 12.sp, color: AppColors.white),
//           ),
//         ),
//         if (controller.showTitles)
//           SizedBox(
//             width: 0,
//             height: 0,
//             child: OverflowBox(
//               fit: OverflowBoxFit.deferToChild,
//               maxHeight: double.maxFinite,
//               maxWidth: double.infinity,
//               child: Container(
//                 margin: EdgeInsets.only(top: 16.r),
//                 child: Text(
//                   controller.stepsList![index],
//                   maxLines: 1,
//                   style: AppTheme.titleTextStyle.copyWith(fontSize: 12.sp, color: index <= controller.index ? AppColors.main : AppColors.unDoneColor),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _wdStepLine(int index) {
//     return Expanded(
//       child: Center(
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Opacity(
//               opacity: 0,
//               child: Text('1', style: AppTheme.titleTextStyle.copyWith(fontSize: 12.sp)),
//             ),
//             Container(
//               height: 2.r,
//               decoration: BoxDecoration(color: index < controller.index ? AppColors.main : AppColors.unDoneColor, borderRadius: BorderRadius.circular(10.r)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CheckoutStepperController extends ChangeNotifier {
//   int _index = 0;

//   /// number of steps
//   final int steps;

//   /// steps titles
//   List<String>? stepsList;

//   /// show titles
//   final bool showTitles;

//   /// create a new instance of CheckoutStepperController
//   CheckoutStepperController({required this.steps, this.stepsList, this.showTitles = true})
//     : assert(steps > 0, 'steps must be greater than 0'),
//       assert(
//         (showTitles == true || stepsList != null) && stepsList?.length == steps,
//         'steps title List must not be null when showTitles is true and titles length must be equal to the number of steps',
//       );

//   /// current step index
//   int get index => _index;

//   /// move to next step
//   void next() {
//     if (_index <= steps) {
//       _index++;
//       notifyListeners();
//     }
//   }

//   /// move to previous step
//   void previous() {
//     if (_index > 0) {
//       _index--;
//       notifyListeners();
//     }
//   }

//   /// reset step index to 0
//   void reset() {
//     _index = 0;
//     notifyListeners();
//   }
// }
