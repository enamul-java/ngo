class SurveyModel {
  final int id;
  final String clientSubmissionId;
  final Map<String, dynamic> answers;
  final Map<String, dynamic> computed;
  final String? submittedAt;
  final String? receivedAt;

  const SurveyModel({
    required this.id,
    required this.clientSubmissionId,
    required this.answers,
    required this.computed,
    this.submittedAt,
    this.receivedAt,
  });

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      id: (json['id'] as num).toInt(),
      clientSubmissionId:
      json['clientSubmissionId'] as String? ?? '',
      answers: Map<String, dynamic>.from(
        json['answers'] as Map? ?? {},
      ),
      computed: Map<String, dynamic>.from(
        json['computed'] as Map? ?? {},
      ),
      submittedAt: json['submittedAt'] as String?,
      receivedAt: json['receivedAt'] as String?,
    );
  }

  String get fullName {
    final firstName = answers['firstName'] ?? '';
    final lastName = answers['lastName'] ?? '';
    return '$firstName $lastName'.trim();
  }

  String get email => answers['email']?.toString() ?? '';

  String get bmiCategory =>
      computed['bmiCategory']?.toString() ?? 'Unknown';

  double? get bmi {
    final value = computed['serverBmi'];
    return value is num ? value.toDouble() : null;
  }

  String get surveyDate =>
      answers['surveyDate']?.toString() ?? '';
}

class PaginatedSurveys {
  final List<SurveyModel> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool last;

  const PaginatedSurveys({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  factory PaginatedSurveys.fromJson(
      Map<String, dynamic> json,
      ) {
    return PaginatedSurveys(
      content: (json['content'] as List<dynamic>? ?? [])
          .map(
            (item) => SurveyModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
      page: (json['number'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 20,
      totalElements:
      (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages:
      (json['totalPages'] as num?)?.toInt() ?? 0,
      last: json['last'] as bool? ?? true,
    );
  }
}



/***
 * Old Model
 */
class SurveyModelOld {
  List<Content>? _content;
  Pageable? _pageable;
  bool? _last;
  int? _totalElements;
  int? _totalPages;
  bool? _first;
  int? _size;
  int? _number;
  Sort? _sort;
  int? _numberOfElements;
  bool? _empty;

  SurveyModelOld(
      {List<Content>? content,
        Pageable? pageable,
        bool? last,
        int? totalElements,
        int? totalPages,
        bool? first,
        int? size,
        int? number,
        Sort? sort,
        int? numberOfElements,
        bool? empty}) {
    if (content != null) {
      this._content = content;
    }
    if (pageable != null) {
      this._pageable = pageable;
    }
    if (last != null) {
      this._last = last;
    }
    if (totalElements != null) {
      this._totalElements = totalElements;
    }
    if (totalPages != null) {
      this._totalPages = totalPages;
    }
    if (first != null) {
      this._first = first;
    }
    if (size != null) {
      this._size = size;
    }
    if (number != null) {
      this._number = number;
    }
    if (sort != null) {
      this._sort = sort;
    }
    if (numberOfElements != null) {
      this._numberOfElements = numberOfElements;
    }
    if (empty != null) {
      this._empty = empty;
    }
  }

  List<Content>? get content => _content;
  set content(List<Content>? content) => _content = content;
  Pageable? get pageable => _pageable;
  set pageable(Pageable? pageable) => _pageable = pageable;
  bool? get last => _last;
  set last(bool? last) => _last = last;
  int? get totalElements => _totalElements;
  set totalElements(int? totalElements) => _totalElements = totalElements;
  int? get totalPages => _totalPages;
  set totalPages(int? totalPages) => _totalPages = totalPages;
  bool? get first => _first;
  set first(bool? first) => _first = first;
  int? get size => _size;
  set size(int? size) => _size = size;
  int? get number => _number;
  set number(int? number) => _number = number;
  Sort? get sort => _sort;
  set sort(Sort? sort) => _sort = sort;
  int? get numberOfElements => _numberOfElements;
  set numberOfElements(int? numberOfElements) =>
      _numberOfElements = numberOfElements;
  bool? get empty => _empty;
  set empty(bool? empty) => _empty = empty;

  SurveyModelOld.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      _content = <Content>[];
      json['content'].forEach((v) {
        _content!.add(new Content.fromJson(v));
      });
    }
    _pageable = json['pageable'] != null
        ? new Pageable.fromJson(json['pageable'])
        : null;
    _last = json['last'];
    _totalElements = json['totalElements'];
    _totalPages = json['totalPages'];
    _first = json['first'];
    _size = json['size'];
    _number = json['number'];
    _sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    _numberOfElements = json['numberOfElements'];
    _empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._content != null) {
      data['content'] = this._content!.map((v) => v.toJson()).toList();
    }
    if (this._pageable != null) {
      data['pageable'] = this._pageable!.toJson();
    }
    data['last'] = this._last;
    data['totalElements'] = this._totalElements;
    data['totalPages'] = this._totalPages;
    data['first'] = this._first;
    data['size'] = this._size;
    data['number'] = this._number;
    if (this._sort != null) {
      data['sort'] = this._sort!.toJson();
    }
    data['numberOfElements'] = this._numberOfElements;
    data['empty'] = this._empty;
    return data;
  }
}

class Content {
  int? _id;
  String? _clientSubmissionId;
  Answers? _answers;
  Computed? _computed;
  String? _submittedAt;
  String? _receivedAt;

  Content(
      {int? id,
        String? clientSubmissionId,
        Answers? answers,
        Computed? computed,
        String? submittedAt,
        String? receivedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (clientSubmissionId != null) {
      this._clientSubmissionId = clientSubmissionId;
    }
    if (answers != null) {
      this._answers = answers;
    }
    if (computed != null) {
      this._computed = computed;
    }
    if (submittedAt != null) {
      this._submittedAt = submittedAt;
    }
    if (receivedAt != null) {
      this._receivedAt = receivedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get clientSubmissionId => _clientSubmissionId;
  set clientSubmissionId(String? clientSubmissionId) =>
      _clientSubmissionId = clientSubmissionId;
  Answers? get answers => _answers;
  set answers(Answers? answers) => _answers = answers;
  Computed? get computed => _computed;
  set computed(Computed? computed) => _computed = computed;
  String? get submittedAt => _submittedAt;
  set submittedAt(String? submittedAt) => _submittedAt = submittedAt;
  String? get receivedAt => _receivedAt;
  set receivedAt(String? receivedAt) => _receivedAt = receivedAt;

  Content.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _clientSubmissionId = json['clientSubmissionId'];
    _answers =
    json['answers'] != null ? new Answers.fromJson(json['answers']) : null;
    _computed = json['computed'] != null
        ? new Computed.fromJson(json['computed'])
        : null;
    _submittedAt = json['submittedAt'];
    _receivedAt = json['receivedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['clientSubmissionId'] = this._clientSubmissionId;
    if (this._answers != null) {
      data['answers'] = this._answers!.toJson();
    }
    if (this._computed != null) {
      data['computed'] = this._computed!.toJson();
    }
    data['submittedAt'] = this._submittedAt;
    data['receivedAt'] = this._receivedAt;
    return data;
  }
}

class Answers {
  String? _firstName;
  String? _lastName;
  String? _surveyDate;
  String? _email;
  String? _phone;
  String? _street;
  String? _street2;
  String? _city;
  String? _stateProvince;
  String? _postalCode;
  List<String>? _preferredContacts;
  String? _birthDate;
  int? _age;
  String? _gender;
  List<String>? _conditions;
  List<Medications>? _medications;
  bool? _pregnant;
  bool? _nursing;
  bool? _foodAllergies;
  String? _allergyDescription;
  int? _heightInches;
  int? _weightLbs;
  double? _currentBmi;
  double? _targetBmi;
  String? _bedTime;
  String? _wakeTime;
  double? _sleepHours;
  bool? _rested;
  String? _sleepQuality;
  int? _waterPerDay;
  int? _coffeePerDay;
  int? _alcoholPerWeek;
  int? _exercisePerWeek;
  List<String>? _exerciseType;
  String? _activityLimitations;
  int? _energyLevel;
  String? _occupation;
  bool? _enjoyWork;
  List<String>? _stressors;
  int? _stressLevel;
  String? _firstMeal;
  String? _lastMeal;
  int? _mealsPerDay;
  int? _snacks;
  String? _eatOutFrequency;
  List<String>? _eatOutLocation;
  int? _currentWeight;
  int? _goalWeight;
  double? _height;
  bool? _triedWeightLoss;
  List<String>? _weightLossDifficulty;
  bool? _smoking;
  String? _exerciseFrequency;
  double? _sleepDuration;

  Answers(
      {String? firstName,
        String? lastName,
        String? surveyDate,
        String? email,
        String? phone,
        String? street,
        String? street2,
        String? city,
        String? stateProvince,
        String? postalCode,
        List<String>? preferredContacts,
        String? birthDate,
        int? age,
        String? gender,
        List<String>? conditions,
        List<Medications>? medications,
        bool? pregnant,
        bool? nursing,
        bool? foodAllergies,
        String? allergyDescription,
        int? heightInches,
        int? weightLbs,
        double? currentBmi,
        double? targetBmi,
        String? bedTime,
        String? wakeTime,
        double? sleepHours,
        bool? rested,
        String? sleepQuality,
        int? waterPerDay,
        int? coffeePerDay,
        int? alcoholPerWeek,
        int? exercisePerWeek,
        List<String>? exerciseType,
        String? activityLimitations,
        int? energyLevel,
        String? occupation,
        bool? enjoyWork,
        List<String>? stressors,
        int? stressLevel,
        String? firstMeal,
        String? lastMeal,
        int? mealsPerDay,
        int? snacks,
        String? eatOutFrequency,
        List<String>? eatOutLocation,
        int? currentWeight,
        int? goalWeight,
        double? height,
        bool? triedWeightLoss,
        List<String>? weightLossDifficulty,
        bool? smoking,
        String? exerciseFrequency,
        double? sleepDuration}) {
    if (firstName != null) {
      this._firstName = firstName;
    }
    if (lastName != null) {
      this._lastName = lastName;
    }
    if (surveyDate != null) {
      this._surveyDate = surveyDate;
    }
    if (email != null) {
      this._email = email;
    }
    if (phone != null) {
      this._phone = phone;
    }
    if (street != null) {
      this._street = street;
    }
    if (street2 != null) {
      this._street2 = street2;
    }
    if (city != null) {
      this._city = city;
    }
    if (stateProvince != null) {
      this._stateProvince = stateProvince;
    }
    if (postalCode != null) {
      this._postalCode = postalCode;
    }
    if (preferredContacts != null) {
      this._preferredContacts = preferredContacts;
    }
    if (birthDate != null) {
      this._birthDate = birthDate;
    }
    if (age != null) {
      this._age = age;
    }
    if (gender != null) {
      this._gender = gender;
    }
    if (conditions != null) {
      this._conditions = conditions;
    }
    if (medications != null) {
      this._medications = medications;
    }
    if (pregnant != null) {
      this._pregnant = pregnant;
    }
    if (nursing != null) {
      this._nursing = nursing;
    }
    if (foodAllergies != null) {
      this._foodAllergies = foodAllergies;
    }
    if (allergyDescription != null) {
      this._allergyDescription = allergyDescription;
    }
    if (heightInches != null) {
      this._heightInches = heightInches;
    }
    if (weightLbs != null) {
      this._weightLbs = weightLbs;
    }
    if (currentBmi != null) {
      this._currentBmi = currentBmi;
    }
    if (targetBmi != null) {
      this._targetBmi = targetBmi;
    }
    if (bedTime != null) {
      this._bedTime = bedTime;
    }
    if (wakeTime != null) {
      this._wakeTime = wakeTime;
    }
    if (sleepHours != null) {
      this._sleepHours = sleepHours;
    }
    if (rested != null) {
      this._rested = rested;
    }
    if (sleepQuality != null) {
      this._sleepQuality = sleepQuality;
    }
    if (waterPerDay != null) {
      this._waterPerDay = waterPerDay;
    }
    if (coffeePerDay != null) {
      this._coffeePerDay = coffeePerDay;
    }
    if (alcoholPerWeek != null) {
      this._alcoholPerWeek = alcoholPerWeek;
    }
    if (exercisePerWeek != null) {
      this._exercisePerWeek = exercisePerWeek;
    }
    if (exerciseType != null) {
      this._exerciseType = exerciseType;
    }
    if (activityLimitations != null) {
      this._activityLimitations = activityLimitations;
    }
    if (energyLevel != null) {
      this._energyLevel = energyLevel;
    }
    if (occupation != null) {
      this._occupation = occupation;
    }
    if (enjoyWork != null) {
      this._enjoyWork = enjoyWork;
    }
    if (stressors != null) {
      this._stressors = stressors;
    }
    if (stressLevel != null) {
      this._stressLevel = stressLevel;
    }
    if (firstMeal != null) {
      this._firstMeal = firstMeal;
    }
    if (lastMeal != null) {
      this._lastMeal = lastMeal;
    }
    if (mealsPerDay != null) {
      this._mealsPerDay = mealsPerDay;
    }
    if (snacks != null) {
      this._snacks = snacks;
    }
    if (eatOutFrequency != null) {
      this._eatOutFrequency = eatOutFrequency;
    }
    if (eatOutLocation != null) {
      this._eatOutLocation = eatOutLocation;
    }
    if (currentWeight != null) {
      this._currentWeight = currentWeight;
    }
    if (goalWeight != null) {
      this._goalWeight = goalWeight;
    }
    if (height != null) {
      this._height = height;
    }
    if (triedWeightLoss != null) {
      this._triedWeightLoss = triedWeightLoss;
    }
    if (weightLossDifficulty != null) {
      this._weightLossDifficulty = weightLossDifficulty;
    }
    if (smoking != null) {
      this._smoking = smoking;
    }
    if (exerciseFrequency != null) {
      this._exerciseFrequency = exerciseFrequency;
    }
    if (sleepDuration != null) {
      this._sleepDuration = sleepDuration;
    }
  }

  String? get firstName => _firstName;
  set firstName(String? firstName) => _firstName = firstName;
  String? get lastName => _lastName;
  set lastName(String? lastName) => _lastName = lastName;
  String? get surveyDate => _surveyDate;
  set surveyDate(String? surveyDate) => _surveyDate = surveyDate;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get street => _street;
  set street(String? street) => _street = street;
  String? get street2 => _street2;
  set street2(String? street2) => _street2 = street2;
  String? get city => _city;
  set city(String? city) => _city = city;
  String? get stateProvince => _stateProvince;
  set stateProvince(String? stateProvince) => _stateProvince = stateProvince;
  String? get postalCode => _postalCode;
  set postalCode(String? postalCode) => _postalCode = postalCode;
  List<String>? get preferredContacts => _preferredContacts;
  set preferredContacts(List<String>? preferredContacts) =>
      _preferredContacts = preferredContacts;
  String? get birthDate => _birthDate;
  set birthDate(String? birthDate) => _birthDate = birthDate;
  int? get age => _age;
  set age(int? age) => _age = age;
  String? get gender => _gender;
  set gender(String? gender) => _gender = gender;
  List<String>? get conditions => _conditions;
  set conditions(List<String>? conditions) => _conditions = conditions;
  List<Medications>? get medications => _medications;
  set medications(List<Medications>? medications) => _medications = medications;
  bool? get pregnant => _pregnant;
  set pregnant(bool? pregnant) => _pregnant = pregnant;
  bool? get nursing => _nursing;
  set nursing(bool? nursing) => _nursing = nursing;
  bool? get foodAllergies => _foodAllergies;
  set foodAllergies(bool? foodAllergies) => _foodAllergies = foodAllergies;
  String? get allergyDescription => _allergyDescription;
  set allergyDescription(String? allergyDescription) =>
      _allergyDescription = allergyDescription;
  int? get heightInches => _heightInches;
  set heightInches(int? heightInches) => _heightInches = heightInches;
  int? get weightLbs => _weightLbs;
  set weightLbs(int? weightLbs) => _weightLbs = weightLbs;
  double? get currentBmi => _currentBmi;
  set currentBmi(double? currentBmi) => _currentBmi = currentBmi;
  double? get targetBmi => _targetBmi;
  set targetBmi(double? targetBmi) => _targetBmi = targetBmi;
  String? get bedTime => _bedTime;
  set bedTime(String? bedTime) => _bedTime = bedTime;
  String? get wakeTime => _wakeTime;
  set wakeTime(String? wakeTime) => _wakeTime = wakeTime;
  double? get sleepHours => _sleepHours;
  set sleepHours(double? sleepHours) => _sleepHours = sleepHours;
  bool? get rested => _rested;
  set rested(bool? rested) => _rested = rested;
  String? get sleepQuality => _sleepQuality;
  set sleepQuality(String? sleepQuality) => _sleepQuality = sleepQuality;
  int? get waterPerDay => _waterPerDay;
  set waterPerDay(int? waterPerDay) => _waterPerDay = waterPerDay;
  int? get coffeePerDay => _coffeePerDay;
  set coffeePerDay(int? coffeePerDay) => _coffeePerDay = coffeePerDay;
  int? get alcoholPerWeek => _alcoholPerWeek;
  set alcoholPerWeek(int? alcoholPerWeek) => _alcoholPerWeek = alcoholPerWeek;
  int? get exercisePerWeek => _exercisePerWeek;
  set exercisePerWeek(int? exercisePerWeek) =>
      _exercisePerWeek = exercisePerWeek;
  List<String>? get exerciseType => _exerciseType;
  set exerciseType(List<String>? exerciseType) => _exerciseType = exerciseType;
  String? get activityLimitations => _activityLimitations;
  set activityLimitations(String? activityLimitations) =>
      _activityLimitations = activityLimitations;
  int? get energyLevel => _energyLevel;
  set energyLevel(int? energyLevel) => _energyLevel = energyLevel;
  String? get occupation => _occupation;
  set occupation(String? occupation) => _occupation = occupation;
  bool? get enjoyWork => _enjoyWork;
  set enjoyWork(bool? enjoyWork) => _enjoyWork = enjoyWork;
  List<String>? get stressors => _stressors;
  set stressors(List<String>? stressors) => _stressors = stressors;
  int? get stressLevel => _stressLevel;
  set stressLevel(int? stressLevel) => _stressLevel = stressLevel;
  String? get firstMeal => _firstMeal;
  set firstMeal(String? firstMeal) => _firstMeal = firstMeal;
  String? get lastMeal => _lastMeal;
  set lastMeal(String? lastMeal) => _lastMeal = lastMeal;
  int? get mealsPerDay => _mealsPerDay;
  set mealsPerDay(int? mealsPerDay) => _mealsPerDay = mealsPerDay;
  int? get snacks => _snacks;
  set snacks(int? snacks) => _snacks = snacks;
  String? get eatOutFrequency => _eatOutFrequency;
  set eatOutFrequency(String? eatOutFrequency) =>
      _eatOutFrequency = eatOutFrequency;
  List<String>? get eatOutLocation => _eatOutLocation;
  set eatOutLocation(List<String>? eatOutLocation) =>
      _eatOutLocation = eatOutLocation;
  int? get currentWeight => _currentWeight;
  set currentWeight(int? currentWeight) => _currentWeight = currentWeight;
  int? get goalWeight => _goalWeight;
  set goalWeight(int? goalWeight) => _goalWeight = goalWeight;
  double? get height => _height;
  set height(double? height) => _height = height;
  bool? get triedWeightLoss => _triedWeightLoss;
  set triedWeightLoss(bool? triedWeightLoss) =>
      _triedWeightLoss = triedWeightLoss;
  List<String>? get weightLossDifficulty => _weightLossDifficulty;
  set weightLossDifficulty(List<String>? weightLossDifficulty) =>
      _weightLossDifficulty = weightLossDifficulty;
  bool? get smoking => _smoking;
  set smoking(bool? smoking) => _smoking = smoking;
  String? get exerciseFrequency => _exerciseFrequency;
  set exerciseFrequency(String? exerciseFrequency) =>
      _exerciseFrequency = exerciseFrequency;
  double? get sleepDuration => _sleepDuration;
  set sleepDuration(double? sleepDuration) => _sleepDuration = sleepDuration;

  Answers.fromJson(Map<String, dynamic> json) {
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _surveyDate = json['surveyDate'];
    _email = json['email'];
    _phone = json['phone'];
    _street = json['street'];
    _street2 = json['street2'];
    _city = json['city'];
    _stateProvince = json['stateProvince'];
    _postalCode = json['postalCode'];
    _preferredContacts = json['preferredContacts'].cast<String>();
    _birthDate = json['birthDate'];
    _age = json['age'];
    _gender = json['gender'];
    _conditions = json['conditions'].cast<String>();
    if (json['medications'] != null) {
      _medications = <Medications>[];
      json['medications'].forEach((v) {
        _medications!.add(new Medications.fromJson(v));
      });
    }
    _pregnant = json['pregnant'];
    _nursing = json['nursing'];
    _foodAllergies = json['foodAllergies'];
    _allergyDescription = json['allergyDescription'];
    _heightInches = json['heightInches'];
    _weightLbs = json['weightLbs'];
    _currentBmi = json['currentBmi'];
    _targetBmi = json['targetBmi'];
    _bedTime = json['bedTime'];
    _wakeTime = json['wakeTime'];
    _sleepHours = json['sleepHours'];
    _rested = json['rested'];
    _sleepQuality = json['sleepQuality'];
    _waterPerDay = json['waterPerDay'];
    _coffeePerDay = json['coffeePerDay'];
    _alcoholPerWeek = json['alcoholPerWeek'];
    _exercisePerWeek = json['exercisePerWeek'];
    _exerciseType = json['exerciseType'].cast<String>();
    _activityLimitations = json['activityLimitations'];
    _energyLevel = json['energyLevel'];
    _occupation = json['occupation'];
    _enjoyWork = json['enjoyWork'];
    _stressors = json['stressors'].cast<String>();
    _stressLevel = json['stressLevel'];
    _firstMeal = json['firstMeal'];
    _lastMeal = json['lastMeal'];
    _mealsPerDay = json['mealsPerDay'];
    _snacks = json['snacks'];
    _eatOutFrequency = json['eatOutFrequency'];
    _eatOutLocation = json['eatOutLocation'].cast<String>();
    _currentWeight = json['currentWeight'];
    _goalWeight = json['goalWeight'];
    _height = json['height'];
    _triedWeightLoss = json['triedWeightLoss'];
    _weightLossDifficulty = json['weightLossDifficulty'].cast<String>();
    _smoking = json['smoking'];
    _exerciseFrequency = json['exerciseFrequency'];
    _sleepDuration = json['sleepDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this._firstName;
    data['lastName'] = this._lastName;
    data['surveyDate'] = this._surveyDate;
    data['email'] = this._email;
    data['phone'] = this._phone;
    data['street'] = this._street;
    data['street2'] = this._street2;
    data['city'] = this._city;
    data['stateProvince'] = this._stateProvince;
    data['postalCode'] = this._postalCode;
    data['preferredContacts'] = this._preferredContacts;
    data['birthDate'] = this._birthDate;
    data['age'] = this._age;
    data['gender'] = this._gender;
    data['conditions'] = this._conditions;
    if (this._medications != null) {
      data['medications'] = this._medications!.map((v) => v.toJson()).toList();
    }
    data['pregnant'] = this._pregnant;
    data['nursing'] = this._nursing;
    data['foodAllergies'] = this._foodAllergies;
    data['allergyDescription'] = this._allergyDescription;
    data['heightInches'] = this._heightInches;
    data['weightLbs'] = this._weightLbs;
    data['currentBmi'] = this._currentBmi;
    data['targetBmi'] = this._targetBmi;
    data['bedTime'] = this._bedTime;
    data['wakeTime'] = this._wakeTime;
    data['sleepHours'] = this._sleepHours;
    data['rested'] = this._rested;
    data['sleepQuality'] = this._sleepQuality;
    data['waterPerDay'] = this._waterPerDay;
    data['coffeePerDay'] = this._coffeePerDay;
    data['alcoholPerWeek'] = this._alcoholPerWeek;
    data['exercisePerWeek'] = this._exercisePerWeek;
    data['exerciseType'] = this._exerciseType;
    data['activityLimitations'] = this._activityLimitations;
    data['energyLevel'] = this._energyLevel;
    data['occupation'] = this._occupation;
    data['enjoyWork'] = this._enjoyWork;
    data['stressors'] = this._stressors;
    data['stressLevel'] = this._stressLevel;
    data['firstMeal'] = this._firstMeal;
    data['lastMeal'] = this._lastMeal;
    data['mealsPerDay'] = this._mealsPerDay;
    data['snacks'] = this._snacks;
    data['eatOutFrequency'] = this._eatOutFrequency;
    data['eatOutLocation'] = this._eatOutLocation;
    data['currentWeight'] = this._currentWeight;
    data['goalWeight'] = this._goalWeight;
    data['height'] = this._height;
    data['triedWeightLoss'] = this._triedWeightLoss;
    data['weightLossDifficulty'] = this._weightLossDifficulty;
    data['smoking'] = this._smoking;
    data['exerciseFrequency'] = this._exerciseFrequency;
    data['sleepDuration'] = this._sleepDuration;
    return data;
  }
}

class Medications {
  String? _name;
  String? _dosage;
  String? _frequency;

  Medications({String? name, String? dosage, String? frequency}) {
    if (name != null) {
      this._name = name;
    }
    if (dosage != null) {
      this._dosage = dosage;
    }
    if (frequency != null) {
      this._frequency = frequency;
    }
  }

  String? get name => _name;
  set name(String? name) => _name = name;
  String? get dosage => _dosage;
  set dosage(String? dosage) => _dosage = dosage;
  String? get frequency => _frequency;
  set frequency(String? frequency) => _frequency = frequency;

  Medications.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _dosage = json['dosage'];
    _frequency = json['frequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['dosage'] = this._dosage;
    data['frequency'] = this._frequency;
    return data;
  }
}

class Computed {
  int? _serverBmi;
  String? _bmiCategory;

  Computed({int? serverBmi, String? bmiCategory}) {
    if (serverBmi != null) {
      this._serverBmi = serverBmi;
    }
    if (bmiCategory != null) {
      this._bmiCategory = bmiCategory;
    }
  }

  int? get serverBmi => _serverBmi;
  set serverBmi(int? serverBmi) => _serverBmi = serverBmi;
  String? get bmiCategory => _bmiCategory;
  set bmiCategory(String? bmiCategory) => _bmiCategory = bmiCategory;

  Computed.fromJson(Map<String, dynamic> json) {
    _serverBmi = json['serverBmi'];
    _bmiCategory = json['bmiCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serverBmi'] = this._serverBmi;
    data['bmiCategory'] = this._bmiCategory;
    return data;
  }
}

class Pageable {
  int? _pageNumber;
  int? _pageSize;
  Sort? _sort;
  int? _offset;
  bool? _paged;
  bool? _unpaged;

  Pageable(
      {int? pageNumber,
        int? pageSize,
        Sort? sort,
        int? offset,
        bool? paged,
        bool? unpaged}) {
    if (pageNumber != null) {
      this._pageNumber = pageNumber;
    }
    if (pageSize != null) {
      this._pageSize = pageSize;
    }
    if (sort != null) {
      this._sort = sort;
    }
    if (offset != null) {
      this._offset = offset;
    }
    if (paged != null) {
      this._paged = paged;
    }
    if (unpaged != null) {
      this._unpaged = unpaged;
    }
  }

  int? get pageNumber => _pageNumber;
  set pageNumber(int? pageNumber) => _pageNumber = pageNumber;
  int? get pageSize => _pageSize;
  set pageSize(int? pageSize) => _pageSize = pageSize;
  Sort? get sort => _sort;
  set sort(Sort? sort) => _sort = sort;
  int? get offset => _offset;
  set offset(int? offset) => _offset = offset;
  bool? get paged => _paged;
  set paged(bool? paged) => _paged = paged;
  bool? get unpaged => _unpaged;
  set unpaged(bool? unpaged) => _unpaged = unpaged;

  Pageable.fromJson(Map<String, dynamic> json) {
    _pageNumber = json['pageNumber'];
    _pageSize = json['pageSize'];
    _sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    _offset = json['offset'];
    _paged = json['paged'];
    _unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this._pageNumber;
    data['pageSize'] = this._pageSize;
    if (this._sort != null) {
      data['sort'] = this._sort!.toJson();
    }
    data['offset'] = this._offset;
    data['paged'] = this._paged;
    data['unpaged'] = this._unpaged;
    return data;
  }
}

class Sort {
  bool? _empty;
  bool? _unsorted;
  bool? _sorted;

  Sort({bool? empty, bool? unsorted, bool? sorted}) {
    if (empty != null) {
      this._empty = empty;
    }
    if (unsorted != null) {
      this._unsorted = unsorted;
    }
    if (sorted != null) {
      this._sorted = sorted;
    }
  }

  bool? get empty => _empty;
  set empty(bool? empty) => _empty = empty;
  bool? get unsorted => _unsorted;
  set unsorted(bool? unsorted) => _unsorted = unsorted;
  bool? get sorted => _sorted;
  set sorted(bool? sorted) => _sorted = sorted;

  Sort.fromJson(Map<String, dynamic> json) {
    _empty = json['empty'];
    _unsorted = json['unsorted'];
    _sorted = json['sorted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empty'] = this._empty;
    data['unsorted'] = this._unsorted;
    data['sorted'] = this._sorted;
    return data;
  }
}
