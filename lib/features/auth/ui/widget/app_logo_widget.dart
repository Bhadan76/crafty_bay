import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/assets_path.dart';

class app_logo_widget extends StatelessWidget {
  const app_logo_widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AssetsPath.logoSvg,width: 120,);
  }
}