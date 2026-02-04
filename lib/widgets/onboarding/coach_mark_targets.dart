import 'package:flutter/material.dart';

class CoachMarkTargets {
  CoachMarkTargets._();

  static final GlobalKey continueCard = GlobalKey(debugLabel: 'coach_continue');
  static final GlobalKey tabLevels = GlobalKey(debugLabel: 'coach_tab_levels');
  static final GlobalKey tabMentors =
      GlobalKey(debugLabel: 'coach_tab_mentors');
  static final GlobalKey gpBadge = GlobalKey(debugLabel: 'coach_gp_badge');
}
