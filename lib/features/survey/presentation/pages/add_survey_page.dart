
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngo/di.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../domain/entity/survey_record.dart';
import '../../domain/usecase/load_latest_survey.dart';
import '../../domain/usecase/save_draft.dart';
import '../../domain/usecase/submit_survey.dart';
import '../../domain/usecase/sync_pending_surveys.dart';
import '../cubit/add_health_survey_cubit.dart';
import '../cubit/add_health_survey_state.dart';
import '../widget/survey_section_card.dart';

class AddSurveyPage extends StatelessWidget {
  const AddSurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddSurveyCubit(
          loadLatestSurvey: getIt<LoadLatestSurvey>(),
          saveDraft: getIt<SaveDraft>(),
          submitSurvey: getIt<SubmitSurvey>(),
          syncPendingSurveys: getIt<SyncPendingSurveys>()
      ),
      /*child: MaterialApp(
        title: 'Health Survey',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B5B)),
          useMaterial3: true,
        ),
        home: const SurveyPage(),
      ),*/
      child: const SurveyPage(),
    );
  }
}


class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  @override
  void initState() {
    super.initState();
    context.read<AddSurveyCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddSurveyCubit, AddSurveyState>(
      listenWhen: (previous, current) => previous.message != current.message && current.message != null,
      listener: (context, state) {
        /*ScaffoldMessenger.of(context).showSnackBar(
         // _getCustomSnacBar(context, state.message),
          SnackBar(content: Text(state.message!), behavior: SnackBarBehavior.floating),
        );*/
        showTopSnackBar(
          Overlay.of(context),
          state.status == SurveyUiStatus.error ? CustomSnackBar.error(
            message: state.message ?? '',
          ): CustomSnackBar.success(
            message: state.message ?? '' + state.status.name,
          ),
        );

      },
      builder: (context, state) {
        final cubit = context.read<AddSurveyCubit>();
        final busy = state.status == SurveyUiStatus.loading ||
            state.status == SurveyUiStatus.submitting ||
            state.status == SurveyUiStatus.saving;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Health Survey'),
            actions: [
              IconButton(
                tooltip: 'Sync pending surveys',
                onPressed: busy ? null : cubit.syncPending,
                icon: const Icon(Icons.sync),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: state.status == SurveyUiStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
            child: Column(
              children: [
                _SurveyHeader(state: state),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      SurveySectionCard(
                        title: 'Personal information',
                        subtitle: 'Basic details and preferred contact',
                        icon: Icons.person_outline_rounded,
                        children: [
                          _field(cubit, state, 'firstName', 'First name'),
                          _field(cubit, state, 'lastName', 'Last name'),
                          _field(cubit, state, 'surveyDate', 'Survey date', hint: 'MM-DD-YYYY'),
                          _field(cubit, state, 'email', 'Email', keyboard: TextInputType.emailAddress),
                          _field(cubit, state, 'phone', 'Phone number', keyboard: TextInputType.phone),
                          _field(cubit, state, 'street', 'Street address'),
                          _field(cubit, state, 'street2', 'Street address line 2'),
                          _field(cubit, state, 'city', 'City'),
                          _field(cubit, state, 'stateProvince', 'State / Province'),
                          _field(cubit, state, 'postalCode', 'Postal / ZIP code'),
                          _multiChoice(cubit, state, 'preferredContacts', 'Preferred contacts',
                              ['Phone Call', 'Email', 'Phone Message', 'Other']),
                          _field(cubit, state, 'birthDate', 'Birth date', hint: 'MM-DD-YYYY'),
                          _field(cubit, state, 'age', 'Age', keyboard: TextInputType.number),
                          _choice(cubit, state, 'gender', 'Gender', ['Female', 'Male', 'Other', 'Prefer not to say']),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SurveySectionCard(
                        title: 'Medical',
                        subtitle: 'Conditions, medications and allergies',
                        icon: Icons.health_and_safety_outlined,
                        children: [
                          _multiChoice(cubit, state, 'conditions', 'Do you have any of the following?',
                              ['High blood pressure', 'Diabetes - Type 1', 'Diabetes - Type 2', 'Gout']),
                          _multiChoice(cubit, state, 'medications', 'Are you taking medications for?',
                              ['Diabetes', 'Thyroid', 'High blood pressure', 'Lithium', 'High cholesterol', 'Coumadin (Warfarin)']),
                          _choice(cubit, state, 'pregnant', 'Are you pregnant?', ['Yes', 'No', 'N/A']),
                          _choice(cubit, state, 'nursing', 'Are you nursing?', ['Yes', 'No']),
                          _choice(cubit, state, 'foodAllergies', 'Do you have food allergies?', ['Yes', 'No']),
                          _field(cubit, state, 'allergyDescription', 'Please describe', maxLines: 3),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SurveySectionCard(
                        title: 'BMI & body measurements',
                        subtitle: 'Measurements as shown in the sample survey',
                        icon: Icons.monitor_weight_outlined,
                        children: [
                          _field(cubit, state, 'heightInches', 'Height in inches', keyboard: TextInputType.number),
                          _field(cubit, state, 'weightLbs', 'Weight in lbs', keyboard: TextInputType.number),
                          _field(cubit, state, 'currentBmi', 'Current BMI number', keyboard: const TextInputType.numberWithOptions(decimal: true)),
                          _field(cubit, state, 'targetBmi', 'BMI for weight you want to maintain', keyboard: const TextInputType.numberWithOptions(decimal: true)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SurveySectionCard(
                        title: 'Sleep',
                        subtitle: 'Routine, duration and sleep quality',
                        icon: Icons.bedtime_outlined,
                        children: [
                          _field(cubit, state, 'bedTime', 'At what time do you go to bed?', hint: 'e.g. 10:30 PM'),
                          _field(cubit, state, 'wakeTime', 'When do you wake up?', hint: 'e.g. 6:30 AM'),
                          _field(cubit, state, 'sleepHours', 'Average hours of sleep', keyboard: const TextInputType.numberWithOptions(decimal: true)),
                          _choice(cubit, state, 'rested', 'Do you wake up feeling rested?', ['Yes', 'No', 'Other']),
                          _field(cubit, state, 'sleepQuality', 'How is the quality of your sleep?', maxLines: 3),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SurveySectionCard(
                        title: 'Hydration',
                        subtitle: 'Daily water and coffee, weekly alcohol',
                        icon: Icons.water_drop_outlined,
                        children: [
                          _field(cubit, state, 'waterPerDay', 'How much water per day?', hint: 'Enter amount and unit'),
                          _field(cubit, state, 'coffeePerDay', 'How much coffee per day?', hint: 'Enter amount and unit'),
                          _field(cubit, state, 'alcoholPerWeek', 'How much alcohol per week?', hint: 'Enter amount and unit'),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SurveySectionCard(
                        title: 'Movement & energy',
                        subtitle: 'Exercise, limitations and daily energy',
                        icon: Icons.directions_run_outlined,
                        children: [
                          _field(cubit, state, 'exercisePerWeek', 'How many times per week do you exercise?', keyboard: TextInputType.number),
                          _field(cubit, state, 'exerciseType', 'What kind of exercise?', maxLines: 2),
                          _field(cubit, state, 'activityLimitations', 'Activities you would like to do but cannot', maxLines: 3),
                          _rating(cubit, state, 'energyLevel', 'Daily energy level', 10, 'Worst', 'Best'),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SurveySectionCard(
                        title: 'Stress',
                        subtitle: 'Work and overall stress level',
                        icon: Icons.psychology_outlined,
                        children: [
                          _field(cubit, state, 'occupation', 'What do you do for work?'),
                          _choice(cubit, state, 'enjoyWork', 'Do you enjoy what you do?', ['Yes', 'No', 'Sometimes']),
                          _field(cubit, state, 'stressors', 'Are there other stressors in your life?', maxLines: 3),
                          _rating(cubit, state, 'stressLevel', 'Overall stress level', 5, 'Lowest', 'Highest'),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SurveySectionCard(
                        title: 'Eating habits',
                        subtitle: 'Meal schedule, snacks and eating out',
                        icon: Icons.restaurant_outlined,
                        children: [
                          _field(cubit, state, 'firstMeal', 'When do you eat your first meal?'),
                          _field(cubit, state, 'lastMeal', 'When do you eat your last meal?'),
                          _field(cubit, state, 'mealsPerDay', 'How many meals per day?', keyboard: TextInputType.number),
                          _field(cubit, state, 'snacks', 'Do you snack? What do you snack on?', maxLines: 3),
                          _choice(cubit, state, 'eatOutFrequency', 'How often do you eat out in a week?',
                              ['Always', 'Usually', 'Sometimes', 'Rarely', 'Never', 'Other']),
                          _field(cubit, state, 'eatOutLocation', 'Where do you typically eat out?', maxLines: 2),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SurveySectionCard(
                        title: 'Weight & lifestyle',
                        subtitle: 'Weight goals, previous attempts, smoking and sleep',
                        icon: Icons.monitor_weight_outlined,
                        children: [
                          _field(cubit, state, 'currentWeight', 'Current weight'),
                          _field(cubit, state, 'goalWeight', 'Goal weight'),
                          _field(cubit, state, 'height', 'Height'),
                          _choice(cubit, state, 'triedWeightLoss', 'Have you tried to lose weight before?', ['Yes', 'No']),
                          _field(cubit, state, 'weightLossDifficulty', 'Most difficult part of losing weight', maxLines: 3),
                          _choice(cubit, state, 'smoking', 'Do you smoke?', ['No', '1 Pack/day', '2 Packs/day', '+3 Packs/day']),
                          _choice(cubit, state, 'exerciseFrequency', 'Do you do any exercise?', ['1 - 3 a week', '3 - 5 a week', 'Everyday', 'Never']),
                          _choice(cubit, state, 'sleepDuration', 'How many hours do you sleep?', ['Less than 5 hours', '5 - 6 hours', '7 - 8 hours', '9 - 10 hours', 'More than 10 hours']),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: .55),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lock_outline),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text('Your answers are saved on this device while you work. Health information is sensitive; submit only when you understand how it will be used.'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: busy ? null : cubit.submit,
                        icon: busy
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.send_rounded),
                        label: Text(busy ? 'Please wait…' : 'Submit survey'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: busy ? null : cubit.saveNow,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Save draft on this device'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 22),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _field(
      AddSurveyCubit cubit,
      AddSurveyState state,
      String key,
      String label, {
        String? hint,
        TextInputType keyboard = TextInputType.text,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        key: ValueKey('field_$key'),
        initialValue: state.answers[key]?.toString() ?? '',
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, hintText: hint),
        onChanged: (value) => cubit.updateAnswer(key, value),
      ),
    );
  }

  Widget _choice(
      AddSurveyCubit cubit,
      AddSurveyState state,
      String key,
      String label,
      List<String> options,
      ) {
    final selected = state.answers[key]?.toString();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: options.map((option) {
              return ChoiceChip(
                label: Text(option),
                selected: selected == option,
                onSelected: (_) => cubit.updateAnswer(key, option),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _multiChoice(
      AddSurveyCubit cubit,
      AddSurveyState state,
      String key,
      String label,
      List<String> options,
      ) {
    final selected = List<String>.from(state.answers[key] as List? ?? const []);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...options.map((option) => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            value: selected.contains(option),
            title: Text(option),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (checked) {
              final next = List<String>.from(selected);
              if (checked == true && !next.contains(option)) next.add(option);
              if (checked != true) next.remove(option);
              cubit.updateAnswer(key, next);
            },
          )),
        ],
      ),
    );
  }

  Widget _rating(
      AddSurveyCubit cubit,
      AddSurveyState state,
      String key,
      String label,
      int max,
      String low,
      String high,
      ) {
    final selected = (state.answers[key] as num?)?.toInt() ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: List.generate(max, (index) {
              final value = index + 1;
              return ChoiceChip(
                label: Text('$value'),
                selected: selected == value,
                onSelected: (_) => cubit.updateAnswer(key, value),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(low, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              Text(high, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}


class _SurveyHeader extends StatelessWidget {
  final AddSurveyState state;
  const _SurveyHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final statusLabel = switch (state.syncStatus) {
      SurveySyncStatus.synced => 'Synced with server',
      SurveySyncStatus.pending => 'Waiting to sync',
      SurveySyncStatus.failed => 'Sync needs attention',
      SurveySyncStatus.draft => 'Draft saved locally',
      null => 'Saved locally as you type',
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF176B5B), Color(0xFF2C8D78)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Your health, your story.', style: TextStyle(color: Colors.white, fontSize: 25, height: 1.15, fontWeight: FontWeight.w800)),
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: .16), borderRadius: BorderRadius.circular(17)),
                  child: const Icon(Icons.favorite_outline_rounded, color: Colors.white, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Complete the survey at your own pace. Your draft stays on this device.', style: TextStyle(color: Colors.white.withValues(alpha: .9))),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: state.progress,
                minHeight: 7,
                backgroundColor: Colors.white.withValues(alpha: .25),
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${(state.progress * 100).round()}% completed', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const Spacer(),
                Flexible(child: Text(statusLabel, textAlign: TextAlign.end, style: const TextStyle(color: Colors.white, fontSize: 12))),
              ],
            ),
            //Text(state.message ?? '', style: TextStyle(color: Colors.red),),
          ],
        ),
      ),
    );
  }
}
