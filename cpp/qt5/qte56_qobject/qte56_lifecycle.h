#pragma once

#ifdef _WIN32
  #ifdef QTE56_QOBJECT_BUILD
    #define QLIFECYCLE_API __declspec(dllexport)
  #else
    #define QLIFECYCLE_API __declspec(dllimport)
  #endif
#else
  #define QLIFECYCLE_API __attribute__((visibility("default")))
#endif

extern "C" {

/// D dtor: 1 — D должна удалить объект; 0 — объект destroyed или имеет Qt parent.
QLIFECYCLE_API int  qte_lifecycle_shouldDelete(void* obj);

/// 1 — C++ объект жив; 0 — destroyed или null.
QLIFECYCLE_API int  qte_lifecycle_isValid(void* obj);

/// Установить глобальный event filter на QApplication для отслеживания parent.
QLIFECYCLE_API void qte_lifecycle_installAppFilter(void* app);

/// Внутренняя: зарегистрировать QObject в lifecycle-трекере.
QLIFECYCLE_API void qte_lifecycle_track(void* obj);

} // extern "C"

/// Шаблон для create-функций: подписывает объект на destroyed() и возвращает его.
/// Использование: return qte_createTracked(new eQWidget(parent));
template <typename T>
T* qte_createTracked(T* obj) {
    qte_lifecycle_track(static_cast<void*>(obj));
    return obj;
}
