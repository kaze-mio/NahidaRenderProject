using UnityEngine;

namespace NahidaRender
{
    public class TransformRotator : MonoBehaviour
    {
        [SerializeField]
        private float m_cycle;

        [SerializeField]
        private Vector3 m_axis;

        private Quaternion m_rotation;

        private float m_startTime;

        private void OnEnable()
        {
            m_rotation = transform.rotation;
            m_startTime = Time.time;
        }

        private void Update()
        {
            float angle = 360f * (Time.time - m_startTime) / m_cycle;
            transform.rotation = Quaternion.AngleAxis(angle, m_axis) * m_rotation;
        }
    }
}
