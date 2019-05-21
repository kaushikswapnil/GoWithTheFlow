class Vehicle
{
 PVector m_Position;
 PVector m_PrevPos;
 PVector m_Velocity;
 PVector m_Acceleration;
 PVector m_Dimensions; //Width, Height
 
 float m_MaxSpeed;
 float m_MaxSteerForce;
 float m_Mass;
 
 float m_SlowdownDistance;
 
 float m_WB_CircleCenterDistance;
 float m_WB_CircleRadius;
 float m_MaxWanderForce;
 
 float m_Color;
 
 Vehicle()
 {
   m_Position = new PVector(random(0, width), random(0, height), ((int)random(numZSlices) * zSliceDistance));
   m_PrevPos = new PVector(0,0); 
   m_Velocity = new PVector(0,0); 
   m_Acceleration = new PVector(0,0); 
   m_Dimensions = new PVector(10,10); 
   m_MaxSpeed = 100.0f;
   m_MaxSteerForce = 10.0f;
   m_Mass = 2.0f;
   m_SlowdownDistance = 50.0f;
   m_WB_CircleCenterDistance = 20.0f;
   m_WB_CircleRadius = 10.0f;
   
   SetColorValueBasedOnPVector(PVector.random2D());
 }
 
 Vehicle(PVector position, PVector velocity, PVector acceleration, PVector dimensions, float maxSpeed, float maxSteerForce, float mass, float slowdownDistance, float wanderCircleCenterDistance, float wanderCircleRadius)
 {
   m_Position = position; 
   m_Velocity = velocity; 
   m_Acceleration = acceleration; 
   m_Dimensions = dimensions; 
   m_MaxSpeed = maxSpeed;
   m_MaxSteerForce = maxSteerForce;
   m_Mass = mass;
   m_SlowdownDistance = slowdownDistance;
   m_WB_CircleCenterDistance = wanderCircleCenterDistance;
   m_WB_CircleRadius = wanderCircleRadius;
   
   SetColorValueBasedOnPVector(PVector.random2D());
 }
 
 void FollowFlow(FlowField flowField)
 {
   PVector desiredVelocity = flowField.GetFlowDirectionAt(m_Position);

   desiredVelocity.mult(m_MaxSpeed);
   
   PVector steeringForce = PVector.sub(desiredVelocity, m_Velocity);
     
   steeringForce.limit(m_MaxSteerForce);
   
   ApplyForce(steeringForce);
 }
 
 void ApplyForce(PVector force)
 {
   PVector resultantAcceleration = PVector.div(force, m_Mass);
    m_Acceleration.add(resultantAcceleration); 
 }
 
 void Update()
 {
   SetColorValueBasedOnAcceleration();
   PhysicsUpdate();
   WrapAroundWalls();
 }
 
 void SetColorValueBasedOnAcceleration()
 {
   SetColorValueBasedOnPVector(m_Acceleration);
 }
 
 void SetColorValueBasedOnPVector(PVector force)
 {
   m_Color = map(force.heading(), 0, TWO_PI, 0, 360);
 }
 
 void Display()
 {  
    strokeWeight(4);
    stroke(m_Color, 255, 255, 200);
    line(m_PrevPos.x, m_PrevPos.y, m_Position.x, m_Position.y);
    //point(m_Position.x, m_Position.y);
    //fill();
    //pushMatrix();
    //translate(m_Position.x, m_Position.y);
    //rotate(theta);
    //beginShape();
    //vertex(0, 2*m_Dimensions.x/3);
    //vertex(-m_Dimensions.x/3, -m_Dimensions.y/2);
    //vertex(-m_Dimensions.x/3, +m_Dimensions.y/2);
    //endShape();
    //popMatrix();
    //ellipse(m_Position.x, m_Position.y, m_Dimensions.x, m_Dimensions.y);
 }
 
 void PhysicsUpdate()
 {
   m_PrevPos = m_Position.get();
   m_Velocity.add(m_Acceleration);
   m_Position.add(m_Velocity);
   
   m_Acceleration.mult(0);
   
   //#TODO should not be here. for testing
   m_Dimensions.x = m_Position.x - m_PrevPos.x;
   m_Dimensions.y = m_Position.y - m_PrevPos.y;
 }
 
 void TurnAwayFromWalls()
 {
   //Turn away from walls
   float wallTurnDistanceOffset = 0.0f;
   if (m_Position.x > (width - m_Dimensions.x - wallTurnDistanceOffset))
   {
      m_Position.x = (width - m_Dimensions.x - wallTurnDistanceOffset);
   }
   else if (m_Position.x - m_Dimensions.x - wallTurnDistanceOffset < 0.0f)
   {
     m_Position.x = m_Dimensions.x + wallTurnDistanceOffset;
   }
   
   if (m_Position.y > (height - m_Dimensions.y - wallTurnDistanceOffset)) 
   {
     m_Position.y = (height - m_Dimensions.y - wallTurnDistanceOffset);
   }
   else if (m_Position.y - m_Dimensions.y - wallTurnDistanceOffset < 0.0f)
   {
     m_Position.y = m_Dimensions.y + wallTurnDistanceOffset;
   }
 }
 
 void WrapAroundWalls()
 {
   if (m_Position.x > width)
   {
      m_PrevPos.x = m_Position.x = 0;
   }
   else if (m_Position.x < 0.0f)
   {
     m_PrevPos.x = m_Position.x = width;
   }
   
   if (m_Position.y > height) 
   {
     m_PrevPos.y = m_Position.y = 0;
   }
   else if (m_Position.y < 0.0f)
   {
     m_PrevPos.y = m_Position.y = height;  
   }
 }
}
