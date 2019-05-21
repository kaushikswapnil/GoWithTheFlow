class ExplosionGenerator
{
   int m_TickCounter;
   boolean m_GenerateForce;
   float m_MaxExplosionMagnitude;
   
   ExplosionGenerator()
   {
      m_TickCounter = 0;
      m_GenerateForce = false;
      m_MaxExplosionMagnitude = 50.0f;
   }
   
   void StartGeneration()
   {
      m_GenerateForce = true; 
   }
   
   void StopGeneration()
   {
      m_GenerateForce = false; 
   }
   
   float TryExplode()
   { 
      float explosionForce = 0.0f;
      if (m_GenerateForce)
      {
         m_TickCounter = m_TickCounter + 1; 
      }
      else if (m_TickCounter > 0)
      {
         explosionForce = m_TickCounter;
         m_TickCounter = 0;
      }
      
      return explosionForce;
   }
}
