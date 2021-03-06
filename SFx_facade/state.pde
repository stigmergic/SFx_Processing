
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import java.util.HashMap;


import org.yaml.snakeyaml.Dumper;
import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Loader;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.AbstractConstruct;
import org.yaml.snakeyaml.constructor.Constructor;
import org.yaml.snakeyaml.nodes.MappingNode;
import org.yaml.snakeyaml.nodes.Node;
import org.yaml.snakeyaml.representer.Represent;
import org.yaml.snakeyaml.representer.Representer;


Yaml yaml;

public void setupState() {
  DumperOptions options = new DumperOptions();
  options.setDefaultFlowStyle(DumperOptions.FlowStyle.FLOW);

  yaml = new Yaml(
  new Loader(new FacadeConstructor()), 
  new Dumper(new FacadeRepresenter(), 
  options));
}

public void saveState(String fname) {
  try {
    FileWriter fw = new FileWriter(new File(dataPath(fname)));
    fw.write(yaml.dump(SFx_facade.this));
    fw.close();
  } 
  catch (IOException e) {
    println("Failed to save state: " + fname);
    e.printStackTrace(); 
    return;
  }
}

public void loadState(String fname, SFx_facade facade) {
  FileReader fr;
  try {
    fr = new FileReader(new File(dataPath(fname)));
    
    //List<Object> data = (List<Object>) yaml.load(fr);
    Object datum = yaml.load(fr);			
    //for (Object datum : data) {
      if (datum instanceof FacadeState) {
	FacadeState state = (FacadeState) datum;
					
					
	if (facade != null && state != null) {
  	  state.applyTo(facade);
	} else {
	  System.out.println("Facade not found: '" + state.getName() + "'");
	}
      }
    //}
  } catch (FileNotFoundException e) {
    e.printStackTrace();
  } catch (NullPointerException e) {
    e.printStackTrace();
    System.out.println("Problem loading.  Trying to ignore...");
  }

}



public class FacadeRepresenter extends Representer {
  public FacadeRepresenter() {
    this.representers.put(SFx_facade.class, new RepresentFacade());
    this.representers.put(RectMask.class, new RepresentMask());
    this.representers.put(TriangleMask.class, new RepresentMask());
    this.representers.put(ParamStates.class, new RepresentParamStates());
    this.representers.put(Fonts.class, new RepresentFonts());
    this.representers.put(Highlights.class, new RepresentHighlights());
      
  }

  private class RepresentFacade implements Represent {
    public Node representData(Object data) {
      SFx_facade facade = (SFx_facade) data;
      Map<String, Object> map = new HashMap<String, Object>();

      map.put("name", facade.thisVersion);
      map.put("bannerX", movingBannerX);       
      map.put("bannerY", movingBannerY);       
      map.put("bannerWidth", bannerWidth); 
      map.put("bannerColor", bannerColor);      
      map.put("masks", masks);
      map.put("params", states);
      map.put("fonts", fonts);
      map.put("highlights", highlights);  
      
      return representMapping("!FacadeState", map, true);
    }
  }
  
  private class RepresentMask implements Represent {
    public Node representData(Object data) {
      Map<String, Object> map = new HashMap<String, Object>();

      Mask mask = (Mask) data;
           
      return representMapping("!FacadeMask", mask.represent(), true);
    }
  }

  private class RepresentParamStates implements Represent {
    public Node representData(Object data) {
      Map<String, Object> map = new HashMap<String, Object>();

      ParamStates states = (ParamStates) data;
           
      return representMapping("!ParamStates", states.represent(), true);
    }
  }
  private class RepresentFonts implements Represent {
    public Node representData(Object data) {
      Map<String, Object> map = new HashMap<String, Object>();

      Fonts fonts = (Fonts) data;
           
      return representMapping("!Fonts", fonts.represent(), true);
    }
  }
  private class RepresentHighlights implements Represent {
    public Node representData(Object data) {
      Map<String, Object> map = new HashMap<String, Object>();

      Highlights highlights = (Highlights) data;
           
      return representSequence("!Highlights", highlights.represent(), true);
    }
  }

}

public class FacadeConstructor extends Constructor {
  public FacadeConstructor() {
    this.yamlConstructors.put("!FacadeState", new ConstructFacade());
    this.yamlConstructors.put("!FacadeMask", new ConstructMask());
    this.yamlConstructors.put("!ParamStates", new ConstructParamStates());
    this.yamlConstructors.put("!Fonts", new ConstructFonts());
    this.yamlConstructors.put("!Highlights", new ConstructHighlights());
  }

  private class ConstructParamStates extends AbstractConstruct {
    @SuppressWarnings("unchecked")
      public Object construct(Node node) {
        Map val = constructMapping((MappingNode) node);
        states.apply(val);
        return states;
      }
  }
  private class ConstructFonts extends AbstractConstruct {
    @SuppressWarnings("unchecked")
      public Object construct(Node node) {
        Map val = constructMapping((MappingNode) node);
        fonts.apply(val);
        return states;
      }
  }
  private class ConstructHighlights extends AbstractConstruct {
    @SuppressWarnings("unchecked")
      public Object construct(Node node) {
        List val = constructSequence((SequenceNode) node);
        highlights.apply(val);
        return states;
      }
  }

  private class ConstructFacade extends AbstractConstruct {
    @SuppressWarnings("unchecked")
      public Object construct(Node node) {
        Map val = constructMapping((MappingNode) node);
        return new FacadeState(val);
      }
  }

  private class ConstructMask extends AbstractConstruct {
    @SuppressWarnings("unchecked")
      public Object construct(Node node) {
        Map val = constructMapping((MappingNode) node);
        if (val.containsKey("type") && val.get("type").equals("RectMask")) {
          masks.add(createRectMask(val));
        } else if (val.containsKey("type") && val.get("type").equals("TriangleMask")) {
          masks.add(createTriangleMask(val));          
        } else {
          for (Object o : val.keySet()) {
           println("key: " + o + " value: " + val.get(o)); 
          }
        }
        return null;
      }
  }
}

public class FacadeState {
  Map<String, Object> map;

  @SuppressWarnings("unchecked")
    public FacadeState(Map val) {
      this.map = val;
    }

  public Integer getId() {
    return (Integer) map.get("id");
  }

  public String getName() {
    return (String) map.get("name");
  }

  @SuppressWarnings("unchecked")
    public void applyTo(SFx_facade facade) {
      if (map.containsKey("name")) facade.name = (String) map.get("name");
      if (map.containsKey("bannerX")) facade.movingBannerX = ((Double) map.get("bannerX")).floatValue();
      if (map.containsKey("bannerY")) facade.movingBannerY = ((Double) map.get("bannerY")).floatValue();
      if (map.containsKey("bannerWidth")) facade.bannerWidth = ((Double) map.get("bannerWidth")).floatValue();
      if (map.containsKey("bannerColor")) facade.bannerColor = ((Integer) map.get("bannerColor"));

      /*
      if (map.containsKey("inPlay")) {
       node.inPlay((Boolean) map.get("inPlay"));
       }
       if (map.containsKey("locked")) {
       node.setLocked((Boolean) map.get("locked"));
       }
       if (map.containsKey("x")) {
       node.setTargetX(((Double) map.get("x")).floatValue() * viewer.getGraphWindowGeometry().width());
       }
       if (map.containsKey("y")) {
       node.setTargetY(((Double) map.get("y")).floatValue() * viewer.getGraphWindowGeometry().height());
       }
       if (map.containsKey("panel")) {
       node.getPanel().setHidden(!((Boolean) map.get("panel")));
       }
       if (map.containsKey("PARAMETERS")) {
       node.getParams().setupParams((Map<String, Object>) map.get("PARAMETERS"));
       }
       if (map.containsKey("COLOR_CHILDREN_BY")) {
       node.colorChildrenBy = viewer.getDataStore().getEntityNode((String) map.get("COLOR_CHILDREN_BY"));
       }
       */
    }
}

