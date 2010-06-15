
ParamStates states = new ParamStates();

boolean is(String name) {
  return states.is(name);  
}

void flip(String name) {
  states.flip(name);  
}

public class ParamStates {
    HashMap<String, Boolean> states = new HashMap<String,Boolean>();
    
    
    void flip(String name) {
      set(name, !is(name));  
    }
    
    void set(String name, Boolean b) {
      states.put(name, b);  
    }

    Boolean is(String name) {      
      if (!states.containsKey(name)) {
        println("adding new state name: " + name + " value: false"); 
        set(name, false);
      }
      
      return states.get(name);  
    }

   Map represent() {
     HashMap<String, Object> map = new HashMap<String,Object>();
  
     for (String name : states.keySet()) {
       map.put(name, is(name));
     }
     
     return map;
   }
   
   void apply(Map map) {
     String name;
     Object val;
     
     for (Object o : map.keySet()) {
       name = (String) o;
       val = map.get(name);
       if (val instanceof Boolean) {
         set(name, (Boolean) val);
       }  
     }
     
   }
}
