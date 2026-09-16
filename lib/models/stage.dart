class StageChoice {
  final String id,text; final List<Map<String,dynamic>> effects; final int nextStage;
  StageChoice({required this.id,required this.text,required this.effects,required this.nextStage});
  factory StageChoice.fromJson(Map<String,dynamic> j)=>StageChoice(id:j['id'],text:j['text'],effects:List<Map<String,dynamic>>.from((j['effects']??[]).map((e)=>Map<String,dynamic>.from(e))),nextStage:j['nextStage']??1);
}
class Stage {
  final int id; final String title,chapter,story; final int age; final List<StageChoice> choices;
  Stage({required this.id,required this.title,required this.chapter,required this.story,required this.age,required this.choices});
  factory Stage.fromJson(Map<String,dynamic> j)=>Stage(id:j['id'],title:j['title'],chapter:j['chapter'],story:j['story'],age:j['age'],choices:List<Map<String,dynamic>>.from((j['choices']??[]).map((e)=>Map<String,dynamic>.from(e))).map(StageChoice.fromJson).toList());
}
