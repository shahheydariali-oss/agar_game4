import 'dart:convert';

class GameState {
  int currentStage;
  int age;
  Map<String, num> vars;
  Set<String> flags;
  List<String> memories;
  List<Map<String, dynamic>> timeline;

  GameState({this.currentStage=1,this.age=22,Map<String,num>? vars,Set<String>? flags,List<String>? memories,List<Map<String,dynamic>>? timeline})
    : vars=vars??{}, flags=flags??{}, memories=memories??[], timeline=timeline??[];

  num get(String key)=>vars[key]??0;
  void add(String key,num value)=>vars[key]=(vars[key]??0)+value;
  Map<String,dynamic> toJson()=>{'currentStage':currentStage,'age':age,'vars':vars,'flags':flags.toList(),'memories':memories,'timeline':timeline};
  factory GameState.fromJson(Map<String,dynamic> j)=>GameState(currentStage:j['currentStage']??1,age:j['age']??22,vars:Map<String,num>.from(j['vars']??{}),flags:Set<String>.from(j['flags']??[]),memories:List<String>.from(j['memories']??[]),timeline:List<Map<String,dynamic>>.from((j['timeline']??[]).map((e)=>Map<String,dynamic>.from(e))));
  String encode()=>jsonEncode(toJson());
  static GameState decode(String s)=>GameState.fromJson(jsonDecode(s));
}
