// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Baby Log';

  @override
  String get homeEditBabyTooltip => 'Edit baby';

  @override
  String get homeEmptyDescription =>
      'Your baby\'s metrics and logs will appear here.';

  @override
  String homeLoadError(Object error) {
    return 'We couldn\'t load the baby\'s information.\n$error';
  }

  @override
  String get formEditTitle => 'Edit baby';

  @override
  String get formCreateTitle => 'Add baby';

  @override
  String get formGenderBoy => 'Boy';

  @override
  String get formGenderGirl => 'Girl';

  @override
  String get formGenderBoySemantic => 'Baby boy';

  @override
  String get formGenderGirlSemantic => 'Baby girl';

  @override
  String get formNameLabel => 'Baby name';

  @override
  String get formNameHint => 'Type the name';

  @override
  String get formNameError => 'The name is required';

  @override
  String get formBirthSection => 'Birth';

  @override
  String get formBirthDateLabel => 'Date';

  @override
  String get formBirthDatePlaceholder => 'Choose the date';

  @override
  String get formBirthTimeLabel => 'Time';

  @override
  String get formBirthTimePlaceholder => 'Choose the time';

  @override
  String get formBirthDateHelp => 'Birth date';

  @override
  String get formBirthTimeHelp => 'Birth time';

  @override
  String get formMeasurementsSection => 'Birth measurements';

  @override
  String get formWeightLabel => 'Weight (kg)';

  @override
  String get formWeightHint => 'e.g. 3.20';

  @override
  String get formHeightLabel => 'Height (cm)';

  @override
  String get formHeightHint => 'e.g. 50.5';

  @override
  String get formInterfaceColorTitle => 'Interface color';

  @override
  String get formInterfaceColorSubtitle => 'Tap to choose the accent color.';

  @override
  String get formColorPickerTitle => 'Interface color';

  @override
  String get formColorPickerConfirm => 'Confirm';

  @override
  String get formSheetCloseTooltip => 'Close';

  @override
  String get formSaveButton => 'Save';

  @override
  String get formPhotoSheetCamera => 'Take photo';

  @override
  String get formPhotoSheetGallery => 'Choose from gallery';

  @override
  String formPhotoLoadError(Object error) {
    return 'We couldn\'t load the image: $error';
  }

  @override
  String get formBirthMissingError => 'Complete the date and time of birth.';

  @override
  String get formUpdateSuccess => 'Profile updated.';

  @override
  String get formCreateSuccess => 'Profile saved.';

  @override
  String formSaveError(Object error) {
    return 'Save failed: $error';
  }

  @override
  String get dashboardBottleLabel => 'Bottle';

  @override
  String get dashboardDiaperLabel => 'Diaper';

  @override
  String get dashboardVomitLabel => 'Vomit';

  @override
  String get dashboardBathLabel => 'Bath';

  @override
  String get dashboardTemperatureLabel => 'Temperature';

  @override
  String get dashboardFoodLabel => 'Feeding';

  @override
  String get dashboardMedicalAgendaLabel => 'Medical agenda';

  @override
  String get dashboardMinutesAgoZero => '0 mins';

  @override
  String get dashboardEventsEmptyTitle => 'No information found';

  @override
  String get dashboardNavHome => 'Home';

  @override
  String get dashboardNavStats => 'Statistics';

  @override
  String get dashboardNavTimeline => 'Timeline';

  @override
  String get dashboardNavDevelopment => 'Development';

  @override
  String get dashboardNavAccount => 'Account';

  @override
  String get dashboardSearchTooltip => 'Search';

  @override
  String get dashboardNotificationsTooltip => 'Notifications';

  @override
  String get dashboardTodayLabel => 'Today';

  @override
  String get dashboardPediatricQuestionsLabel => 'Ask the pediatrician';
}
