import '../models/game_state.dart';
import '../models/stage.dart';
class StoryEngine {
  final List<Stage> stages; StoryEngine(this.stages);
  Stage stage(int id)=>stages.firstWhere((s)=>s.id==id);
  void effects(GameState s,List<Map<String,dynamic>> es){
    for(final e in es){final op=e['op'];final k=e['key'];final v=e['value']; if(op=='ADD')s.add(k,(v as num?)??0); if(op=='SET')s.vars[k]=(v as num?)??0; if(op=='FLAG' && v==true)s.flags.add(k);}
  }
  void choose(GameState s,Stage st,StageChoice c){
    s.timeline.add({'stage':st.id,'choice':c.id}); effects(s,c.effects); s.memories.add('stage_${st.id}'); s.currentStage=c.nextStage; final n=stage(s.currentStage); if(n.age>s.age)s.age=n.age;
  }
}
