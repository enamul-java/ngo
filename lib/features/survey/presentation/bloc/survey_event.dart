
abstract class SurveyEvent{}
class GetSurveyList implements SurveyEvent{
   int? page;
   int? size;
   GetSurveyList({this.page, this.size});
}