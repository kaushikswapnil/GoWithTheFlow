class FlowField
{
   PVector[][] m_Field;
   int m_Columns, m_Rows;
   int m_Resolution;

   FlowField()
   {
      m_Resolution = 10;
      m_Columns = width/m_Resolution;
      m_Rows = height/m_Resolution;
      
      m_Field = new PVector[m_Columns][m_Rows];
   }
   
   FlowField(int resolution)
   {
      m_Resolution = resolution;
      m_Columns = width/m_Resolution;
      m_Rows = height/m_Resolution;
      
      m_Field = new PVector[m_Columns][m_Rows];
   }
   
   void Init()
   {
      CreateNewField();
   }
   
   void CreateNewField()
   {
     noiseSeed((int)random(10000));
     IterateFlow(0, 0, 0);
   }
   
   void IterateFlow(float xMove, float yMove, float zMove)
   {
     float xOffset = 0.3f;
     float zOffset =0.02;
     for (int colIter = 0; colIter < m_Columns; ++colIter)
      {
        float yOffset = 0.0f;
        for (int rowIter = 0; rowIter < m_Rows; ++rowIter)
        {
          float theta = map(noise(xOffset + xMove, yOffset + yMove, zOffset + zMove), 0, 1, 0, TWO_PI);
          m_Field[colIter][rowIter] = new PVector(cos(theta), sin(theta));
          yOffset += 0.1f;
        }
        xOffset += 0.006;
        zOffset += 0.01f;
      }
   }
   
   PVector GetFlowDirectionAt(PVector position)
   {
      return GetFlowDirectionAt(position.x, position.y); 
   }
   
   PVector GetFlowDirectionAt(float x, float y)
   {
      int col = constrain((int)(x/m_Resolution), 0 , m_Columns - 1); 
      int row = constrain((int)(y/m_Resolution), 0 , m_Rows - 1);
      
      return m_Field[col][row].copy();
   }
   
   PVector GetFlowDirectionAt(float x, float y, float xMove, float sliceZ, float yMove, float zMove)
   {
      float theta = map(noise(x + xMove, y + yMove, sliceZ + zMove), 0.0, 1.0, 0, TWO_PI);
      PVector flow = new PVector(cos(theta), sin(theta));
      return flow;
   }
   
   void Display()
   {
     for (int colIter = 0; colIter < m_Columns; ++colIter)
      {
        for (int rowIter = 0; rowIter < m_Rows; ++rowIter)
        {
          pushMatrix();
          translate(colIter*m_Resolution, rowIter*m_Resolution);
          stroke(255, 150);
          PVector flowVector = m_Field[colIter][rowIter];
          rotate(flowVector.heading());
          line(0, 0, flowVector.mag()*(m_Resolution - 2), 0);
          popMatrix();
        }
      }
   }
}
