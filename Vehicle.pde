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
 
 PVector m_Color;
 
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
   
   m_Color = new PVector(random(0,255), random(0,255), random(0,255));
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
   
   m_Color = new PVector(random(0,255), random(0,255), random(0,255));
 }
 
 void Seek(PVector targetPosition)
 {
   PVector displacementToTarget = PVector.sub(targetPosition, m_Position);
   PVector desiredVelocity = displacementToTarget.copy();
   desiredVelocity.normalize();

   desiredVelocity.mult(m_MaxSpeed);
   
   PVector steeringForce = PVector.sub(desiredVelocity, m_Velocity);
     
   steeringForce.limit(m_MaxSteerForce);
   
   ApplyForce(steeringForce);
 }
 
 void Wander()
 {
     PVector circleCenterVector = m_Velocity.copy();
     circleCenterVector.normalize();
     circleCenterVector.mult(m_WB_CircleCenterDistance);
     
     PVector relativeDisplacementForWanderPoint = new PVector(1.0f, 0.0f);
     float randomRotationAngle = map(random(0, 1), 0.0f, 1.0f, 0.0f, 2 * PI);
     relativeDisplacementForWanderPoint.rotate(randomRotationAngle);
     relativeDisplacementForWanderPoint.mult(m_WB_CircleRadius);
     
     PVector displacementForWanderPoint = PVector.add(relativeDisplacementForWanderPoint, m_Position);
     
     Seek(displacementForWanderPoint);
 }
 
 void FollowFlow(FlowField flowField)
 {
   PVector desiredVelocity = GetFlowDirectionAt(m_Position, flowField);
   
   if (movingFlowField && isDebugModeOn)
   {
      //stroke(255);
      //line(m_Position.x, m_Position.y, m_Position.x + (5 * desiredVelocity.x), m_Position.y + (5 * desiredVelocity.y));
   }
   desiredVelocity.mult(m_MaxSpeed);
   
   PVector desiredLocation = PVector.add(desiredVelocity, m_Position);
   
   Seek(desiredLocation);
 }
 
 void ApplyForce(PVector force)
 {
   PVector resultantAcceleration = PVector.div(force, m_Mass);
    m_Acceleration.add(resultantAcceleration); 
 }
 
 void Update()
 {
   IterateColorBasedOnAcceleration();
   PhysicsUpdate();
   WrapAroundWalls();
 }
 
 void IterateColorBasedOnAcceleration()
 {
   m_Color = m_Acceleration.copy();
 }
 
 void Display()
 {  
    strokeWeight(4);
    stroke(map(m_Color.heading(), 0, TWO_PI, 0, 360), 255, 255, 200);
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
   m_PrevPos = m_Position.copy();
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
