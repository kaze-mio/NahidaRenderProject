using UnityEngine;

namespace Nahida
{
    public class TransformRotator : MonoBehaviour
    {
        [SerializeField]
        private float m_Cycle;

        [SerializeField]
        private Vector3 m_Axis;

        private Quaternion _rotation;

        private float _startTime;

        private void OnEnable()
        {
            _rotation = transform.rotation;
            _startTime = Time.time;
        }

        private void Update()
        {
            float angle = 360f * (Time.time - _startTime) / m_Cycle;
            transform.rotation = Quaternion.AngleAxis(angle, m_Axis) * _rotation;
        }
    }
}
