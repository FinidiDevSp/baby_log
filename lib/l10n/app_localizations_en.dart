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
  String get homeLogActionsTooltip => 'Manage entry';

  @override
  String get homeLogEditAction => 'Edit entry';

  @override
  String get homeLogDeleteAction => 'Delete entry';

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
  String get dashboardMedicalAgendaLabel => 'AGENDA';

  @override
  String get agendaTitle => 'Medical agenda';

  @override
  String get agendaNewAppointmentTooltip => 'Add appointment';

  @override
  String get agendaCreateTitle => 'New appointment';

  @override
  String get agendaEditTitle => 'Edit appointment';

  @override
  String get agendaFormTitleLabel => 'Title';

  @override
  String get agendaFormTitleError => 'Add a short title';

  @override
  String get agendaFormTypeLabel => 'Appointment type';

  @override
  String get agendaFormDateTimeLabel => 'Date and time';

  @override
  String get agendaFormDateTimeError => 'Select the exact date and time';

  @override
  String get agendaFormNotesLabel => 'Notes';

  @override
  String get agendaFormCancel => 'Cancel';

  @override
  String get agendaFormSaveNew => 'Save appointment';

  @override
  String get agendaFormSaveChanges => 'Save changes';

  @override
  String get agendaSectionToday => 'Today';

  @override
  String get agendaSectionUpcoming => 'Upcoming';

  @override
  String get agendaSectionPast => 'Past';

  @override
  String get agendaPastIndicator => 'Completed';

  @override
  String get agendaEmptyDescription => 'You have no medical appointments yet.';

  @override
  String get agendaEditAction => 'Edit';

  @override
  String get agendaDeleteAction => 'Delete';

  @override
  String get agendaDeleteConfirmTitle => 'Remove appointment';

  @override
  String get agendaDeleteConfirmMessage =>
      'This appointment will be permanently removed.';

  @override
  String get agendaDeleteConfirmCancel => 'Keep';

  @override
  String get agendaDeleteConfirmAccept => 'Delete';

  @override
  String get agendaCreateSuccess => 'Appointment saved.';

  @override
  String get agendaUpdateSuccess => 'Appointment updated.';

  @override
  String get agendaDeleteSuccess => 'Appointment deleted.';

  @override
  String get agendaTypeRevision => 'Check-up';

  @override
  String get agendaTypePediatrics => 'Pediatrics';

  @override
  String get agendaTypeVaccines => 'Vaccines';

  @override
  String get agendaTypeEmergency => 'Emergency';

  @override
  String get dashboardAgendaStatusToday => 'Today';

  @override
  String get dashboardAgendaStatusTomorrow => 'Tomorrow';

  @override
  String dashboardAgendaStatusInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count days',
      one: 'In 1 day',
    );
    return '$_temp0';
  }

  @override
  String dashboardQuestionsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending',
      one: '$count pending',
    );
    return '$_temp0';
  }

  @override
  String get dashboardQuestionsAllClear => 'All clear';

  @override
  String get dashboardElapsedJustNow => 'Just now';

  @override
  String dashboardElapsedMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mins ago',
      one: '1 min ago',
    );
    return '$_temp0';
  }

  @override
  String dashboardElapsedHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hrs ago',
      one: '1 hr ago',
    );
    return '$_temp0';
  }

  @override
  String dashboardElapsedDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

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
  String get dashboardChangeDayTooltip => 'Choose another day';

  @override
  String get dashboardImportTooltip => 'Import data';

  @override
  String dashboardImportSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries imported successfully.',
      one: '1 entry imported successfully.',
      zero: 'No entries were imported.',
    );
    return '$_temp0';
  }

  @override
  String dashboardImportError(String reason) {
    return 'Could not import the file: $reason';
  }

  @override
  String get dashboardImportReadError => 'The selected file could not be read.';

  @override
  String get dashboardExportTooltip => 'Export data';

  @override
  String get dashboardPediatricQuestionsLabel => 'Questions';

  @override
  String get bottleLogTitle => 'Bottle feeding';

  @override
  String get bottleLogDateTimeLabel => 'Date & time';

  @override
  String get bottleLogAmountLabel => 'Amount';

  @override
  String get bottleLogAmountUnit => 'ml';

  @override
  String get bottleLogNotesLabel => 'Notes';

  @override
  String get bottleLogNotesHint => 'Add any details you want to remember';

  @override
  String get bottleLogAmountValidation => 'Enter a valid amount';

  @override
  String get bottleLogDecreaseTooltip => 'Decrease 5 ml';

  @override
  String get bottleLogIncreaseTooltip => 'Increase 5 ml';

  @override
  String get homeLogListTitle => 'Latest logs';

  @override
  String get bathLogTitle => 'Bath';

  @override
  String get bathLogTypeLabel => 'Bath type';

  @override
  String get bathLogTypeFullOption => 'Complete';

  @override
  String get bathLogTypeQuickOption => 'Quick';

  @override
  String get bathLogTypeFullDescription => 'Complete bath';

  @override
  String get bathLogTypeQuickDescription => 'Quick bath';

  @override
  String get bathLogNotesLabel => 'Notes';

  @override
  String get bathLogNotesHint => 'Add any details you want to remember';

  @override
  String get stoolLogTitle => 'Diaper change';

  @override
  String get stoolLogDateTimeLabel => 'Date & time';

  @override
  String get stoolLogConsistencyLabel => 'Consistency';

  @override
  String get stoolLogConsistencyLiquidOption => 'Liquid';

  @override
  String get stoolLogConsistencySoftOption => 'Soft';

  @override
  String get stoolLogConsistencyFirmOption => 'Firm';

  @override
  String get stoolLogConsistencyLiquidDescription => 'Liquid stool';

  @override
  String get stoolLogConsistencySoftDescription => 'Soft stool';

  @override
  String get stoolLogConsistencyFirmDescription => 'Firm stool';

  @override
  String get stoolLogNotesLabel => 'Notes';

  @override
  String get stoolLogNotesHint => 'Add any detail you want to remember';

  @override
  String get stoolLogConsistencyValidation => 'Select a consistency option';

  @override
  String get vomitLogTitle => 'Vomit log';

  @override
  String get vomitLogAmountLabel => 'Amount';

  @override
  String get vomitLogAmountLowOption => 'Low';

  @override
  String get vomitLogAmountMediumOption => 'Medium';

  @override
  String get vomitLogAmountHighOption => 'High';

  @override
  String get vomitLogAmountLowDescription => 'Light vomit';

  @override
  String get vomitLogAmountMediumDescription => 'Moderate vomit';

  @override
  String get vomitLogAmountHighDescription => 'Abundant vomit';

  @override
  String get vomitLogNotesLabel => 'Notes';

  @override
  String get vomitLogNotesHint => 'Add any detail you want to remember';

  @override
  String get vomitLogAmountValidation => 'Select an amount option';

  @override
  String get temperatureLogTitle => 'Temperature';

  @override
  String get temperatureLogValueLabel => 'Temperature';

  @override
  String get temperatureLogValueUnit => '°C';

  @override
  String get temperatureLogDecreaseTooltip => 'Decrease 0.1 °C';

  @override
  String get temperatureLogIncreaseTooltip => 'Increase 0.1 °C';

  @override
  String get temperatureLogValueValidation => 'Enter a valid temperature';

  @override
  String get temperatureLogNotesLabel => 'Notes';

  @override
  String get temperatureLogNotesHint => 'Add any notes you want to remember';

  @override
  String get bottleLogListTitle => 'Latest feedings';

  @override
  String get questionsTitle => 'Questions';

  @override
  String get questionsShareTooltip => 'Share pending questions';

  @override
  String get questionsShareTitle => 'Questions for the pediatrician';

  @override
  String get questionsShareMessage =>
      'These are the topics we want to discuss in our next appointment.';

  @override
  String questionsShareError(Object error) {
    return 'Couldn\'t share: $error';
  }

  @override
  String get questionsValidationMessage => 'Write the question before saving.';

  @override
  String questionsSaveError(Object error) {
    return 'Couldn\'t save the question: $error';
  }

  @override
  String questionsUpdateError(Object error) {
    return 'Couldn\'t update the question: $error';
  }

  @override
  String questionsDeleteError(Object error) {
    return 'Couldn\'t delete the question: $error';
  }

  @override
  String get questionsComposerTitle => 'Write your question';

  @override
  String get questionsComposerPlaceholder =>
      'E.g. Ask about starting solid food';

  @override
  String get questionsComposerAction => 'Save question';

  @override
  String get questionsComposerUpdateAction => 'Update question';

  @override
  String get questionsComposerEditingNotice => 'Editing a saved question';

  @override
  String get questionsComposerCancelEditing => 'Cancel editing';

  @override
  String get questionsPendingSection => 'Pending';

  @override
  String get questionsResolvedSection => 'Resolved';

  @override
  String get questionsDeleteDialogTitle => 'Delete question?';

  @override
  String get questionsDeleteDialogMessage =>
      'This will remove the question from the list.';

  @override
  String get questionsDeleteDialogConfirm => 'Delete';

  @override
  String get questionsEditDialogTitle => 'Edit question';

  @override
  String get questionsEditDialogLabel => 'Question';

  @override
  String get questionsEditDialogCancel => 'Cancel';

  @override
  String get questionsEditDialogSave => 'Save';

  @override
  String get questionsEditAction => 'Edit';

  @override
  String get questionsDeleteAction => 'Delete';

  @override
  String get questionsEmptyTitle => 'Capture your doubts';

  @override
  String get questionsEmptySubtitle =>
      'Write down what you want to ask during the next pediatric visit.';

  @override
  String get questionsLoadError =>
      'We couldn\'t load your questions. Please try again.';

  @override
  String get questionsAgeUnknown => 'Age unavailable';

  @override
  String get questionsAgeLessThanWeek => 'Less than a week';

  @override
  String questionsAgeWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '$count week',
    );
    return '$_temp0';
  }

  @override
  String questionsAgeMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '$count month',
    );
    return '$_temp0';
  }

  @override
  String questionsAgeMonthsAndWeeks(int months, int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '$months month',
    );
    String _temp1 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks weeks',
      one: '$weeks week',
    );
    return '$_temp0 and $_temp1';
  }

  @override
  String get questionsSatisfactionTitle => 'How did it go?';

  @override
  String get questionsSatisfactionSubtitle =>
      'Let us know how satisfied you feel with the answer.';

  @override
  String get questionsSatisfactionHappy => 'Satisfied';

  @override
  String get questionsSatisfactionNeutral => 'Neutral';

  @override
  String get questionsSatisfactionSad => 'Unsatisfied';

  @override
  String get questionsSatisfactionNoteLabel => 'Additional notes';

  @override
  String get questionsSatisfactionConfirm => 'Save';

  @override
  String get questionsSatisfactionCancel => 'Cancel';

  @override
  String get accountSettingsTitle => 'My account';

  @override
  String get accountSettingsSubtitle => 'Manage your personal preferences.';

  @override
  String get accountLanguageTitle => 'App language';

  @override
  String get accountLanguageSubtitle =>
      'Choose the language you prefer for BabyLog.';

  @override
  String get accountLanguageOptionSpanish => 'Spanish';

  @override
  String get accountLanguageOptionEnglish => 'English';

  @override
  String get accountLanguageApplyHint =>
      'Changes apply immediately and are remembered for next time.';

  @override
  String get statsCategoryFeeding => 'Bottle';

  @override
  String get statsCategoryDiapers => 'Diaper';

  @override
  String get statsCategoryBath => 'Bath';

  @override
  String get statsCategoryVomit => 'Vomit';

  @override
  String statsWeekLabel(Object range) {
    return '$range';
  }

  @override
  String get statsWeekSubtitle => 'Data from Monday to Sunday';

  @override
  String get statsWeekPreviousTooltip => 'Previous week';

  @override
  String get statsWeekNextTooltip => 'Next week';

  @override
  String get statsRangePickerTitle => 'Select a date range';

  @override
  String get statsRangeTooLongMessage => 'Please choose 30 days or fewer.';

  @override
  String get statsMetricTotalLabel => 'Total';

  @override
  String get statsMetricDailyAverageLabel => 'Day';

  @override
  String get statsMetricDominantLabel => 'Dominant';

  @override
  String get statsMetricEmptyValue => '—';

  @override
  String get statsFeedingCountTitle => 'Feeding count';

  @override
  String get statsFeedingVolumeTitle => 'Daily volume';

  @override
  String get statsDiaperCountTitle => 'Diaper changes';

  @override
  String get statsDiaperConsistencyTitle => 'Average consistency';

  @override
  String get statsBathCountTitle => 'Bath sessions';

  @override
  String get statsVomitCountTitle => 'Vomit events';

  @override
  String get statsVomitIntensityTitle => 'Average intensity';

  @override
  String get statsConsistencyLiquid => 'Liquid';

  @override
  String get statsConsistencySoft => 'Soft';

  @override
  String get statsConsistencyFirm => 'Firm';

  @override
  String get statsChartYAxisTimes => 'Times';

  @override
  String get statsChartYAxisVolume => 'Milliliters';

  @override
  String get statsChartYAxisConsistency => 'Consistency';

  @override
  String get statsChartYAxisIntensity => 'Intensity';

  @override
  String get statsChartLegendSelected => 'Selected period';

  @override
  String get statsChartLegendTrend => 'Trend line';

  @override
  String get statsEmptyState => 'No records for this week yet.';
}
