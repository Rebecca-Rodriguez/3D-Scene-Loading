class Scene
{
  BufferedReader reader;
  String line;
  ArrayList<String> fileInfo = new ArrayList<String>();

  ArrayList<PShape> objs = new ArrayList<PShape>();
  ArrayList<PVector> drawLocations = new ArrayList<PVector>();
  ArrayList<Integer> drawColors = new ArrayList<Integer>();
  ArrayList<PVector> lightLocations = new ArrayList<PVector>();
  ArrayList<PVector> lightColors = new ArrayList<PVector>();

  color backgroundColor = color(0, 0, 0);

  Scene(String fileName)
  {
    // catch any errors in filename
    if (fileName == null)
    {
      println("ERROR");
      return;
    }

    // get all lines from text file
    LoadScene(fileName);

    if (fileName.contains("testfile"))
    {
      AssignTestValues(fileInfo);
    } else if (fileName.contains("scene1") || fileName.contains("scene2"))
    {
      AssignSceneValues(fileInfo);
    } else
    {
      println("ERROR");
      return;
    }
  }

  void LoadScene(String fileName)
  {
    reader = createReader(fileName);

    // save the data from the file into String line
    try {
      while ((line = reader.readLine()) != null)
      {
        fileInfo.add(line);
      }
    }
    catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
  }

  void AssignTestValues(ArrayList<String> fileInfo)
  {
    String[] pieces;

    // items from first line
    pieces = split(fileInfo.get(0), ",");
    objs.add(loadShape("models/" + pieces[0] + ".obj"));
    drawLocations.add(new PVector(float(pieces[1]), float(pieces[2]), float(pieces[3])));
    drawColors.add(color(int(pieces[4]), int(pieces[5]), int(pieces[6])));

    // items from second line
    pieces = split(fileInfo.get(1), ",");
    lightLocations.add(new PVector(float(pieces[0]), float(pieces[1]), float(pieces[2])));
    lightColors.add(new PVector(float(pieces[3]), float(pieces[4]), float(pieces[5])));
  }


  void AssignSceneValues(ArrayList<String> fileInfo)
  {
    int currIndex = 0;      // used to keep track of what line the function is reading

    // background color from first line
    String[] colorValues = split(fileInfo.get(currIndex++), ",");
    backgroundColor = color(int(colorValues[0]), int(colorValues[1]), int(colorValues[2]));

    // number indicating how many meshes are referenced in the scene
    int numMeshes = int(fileInfo.get(currIndex++));
    for (int i = 0; i < numMeshes; i++)
    {
      String[] pieces = split(fileInfo.get(currIndex++), ",");
      objs.add(loadShape("models/" + pieces[0] + ".obj"));
      drawLocations.add(new PVector(float(pieces[1]), float(pieces[2]), float(pieces[3])));
      drawColors.add(color(int(pieces[4]), int(pieces[5]), int(pieces[6])));
    }

    // number representing how many lights are in the scene
    int numLights = int(fileInfo.get(currIndex++));
    for (int i = 0; i < numLights; i++)
    {
      String[] pieces = split(fileInfo.get(currIndex++), ",");
      lightLocations.add(new PVector(float(pieces[0]), float(pieces[1]), float(pieces[2])));
      lightColors.add(new PVector(float(pieces[3]), float(pieces[4]), float(pieces[5])));
    }
  }


  void DrawScene()
  {
    background(backgroundColor);

    for (int i = 0; i < lightLocations.size(); i++)
    {
      pointLight(lightColors.get(i).x, lightColors.get(i).y, lightColors.get(i).z, lightLocations.get(i).x, lightLocations.get(i).x, lightLocations.get(i).x);
    }


    for (int i = 0; i < objs.size(); i++)
    {
      pushMatrix();
      translate(drawLocations.get(i).x, drawLocations.get(i).y, drawLocations.get(i).z);
      objs.get(i).setFill(drawColors.get(i));
      shape(objs.get(i));
      popMatrix();
    }
  }

  String GetShapeCount()
  {
    return(String.valueOf(objs.size()));
  }

  String GetLightCount()
  {
    return(String.valueOf(lightLocations.size()));
  }
}
