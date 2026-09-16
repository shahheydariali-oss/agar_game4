import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
class SaveService { static const key='agar_save'; Future<void> save(GameState s)async{final p=await SharedPreferences.getInstance();await p.setString(key,s.encode());} Future<GameState?> load()async{final p=await SharedPreferences.getInstance();final x=p.getString(key);return x==null?null:GameState.decode(x);} Future<void> clear()async{final p=await SharedPreferences.getInstance();await p.remove(key);}}
