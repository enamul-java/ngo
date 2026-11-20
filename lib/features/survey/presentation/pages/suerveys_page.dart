import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../di.dart';
import '../../data/model/survey_model.dart';
import '../cubit/health_surrey_cubit.dart';
import '../cubit/health_survey_state.dart';


class SurveyApp extends StatelessWidget {
  const SurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NGO Auth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: BlocProvider(
        create: (_) => getIt<HealthSurveyCubit>()
          ..fetchSurveys(page: 0, size: 20),
        child: const HealthSurveyPage(),
      ),
    );
  }
}
class HealthSurveyPage extends StatelessWidget {
  const HealthSurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Surveys'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HealthSurveyCubit>().fetchSurveys();
            },
          ),
        ],
      ),
      body: BlocBuilder<HealthSurveyCubit, HealthSurveyState>(
        builder: (context, state) {
          if (state is HealthSurveyInitial ||
              state is HealthSurveyLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is HealthSurveyError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<HealthSurveyCubit>()
                            .fetchSurveys();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is HealthSurveyLoaded) {
            final result = state.result;

            if (result.content.isEmpty) {
              return const Center(
                child: Text('No health surveys found.'),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context
                  .read<HealthSurveyCubit>()
                  .fetchSurveys(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Total submissions: ${result.totalElements}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...result.content.map(
                        (survey) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const CircleAvatar(
                          child: Icon(Icons.assignment_outlined),
                        ),
                        title: Text(survey.fullName),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text('Email: ${survey.email}'),
                              Text('Date: ${survey.surveyDate}'),
                              Text(
                                'BMI: ${survey.bmi?.toStringAsFixed(1) ?? 'N/A'}'
                                    ' (${survey.bmiCategory})',
                              ),
                              const SizedBox(height: 6),
                              const Text('Submitted'),
                            ],
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SurveyDetailsPage(
                                survey: survey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (!result.last)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          context
                              .read<HealthSurveyCubit>()
                              .fetchSurveys(
                            page: result.page + 1,
                            size: result.size,
                          );
                        },
                        child: const Text('Load next page'),
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAlertDialog(context, "Hi");
        },
        child: const Icon(Icons.add, color: Colors.blue,),
      ),*/

    );
  }

  void showAlertDialog(BuildContext context, String message){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Alert Dialog Box"),
        content: const Text("You have raised an Alert Dialog Box"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("okay"),
          ),
        ],
      ),
    );
  }
}

class SurveyDetailsPage extends StatelessWidget {
  final SurveyModel survey;

  const SurveyDetailsPage({
    super.key,
    required this.survey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Survey Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            survey.fullName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Submission ID: ${survey.clientSubmissionId}'),
          Text('Email: ${survey.email}'),
          Text('Survey date: ${survey.surveyDate}'),
          Text('BMI: ${survey.bmi ?? 'N/A'}'),
          Text('Category: ${survey.bmiCategory}'),
          const Divider(height: 32),
          Text(
            'All Answers',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...survey.answers.entries.map(
                (entry) => ListTile(
              title: Text(entry.key),
              subtitle: Text(
                entry.value?.toString() ?? 'N/A',
              ),
              dense: true,
            ),
          ),
          const Divider(height: 32),
          Text(
            'Computed Results',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ...survey.computed.entries.map(
                (entry) => ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value.toString()),
              dense: true,
            ),
          ),
        ],
      ),
    );
  }
}
