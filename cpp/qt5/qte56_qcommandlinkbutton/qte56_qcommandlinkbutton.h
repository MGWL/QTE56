#pragma once

#ifdef _WIN32
  #ifdef QTE56_QCOMMANDLINKBUTTON_BUILD
    #define QCOMMANDLINKBUTTON_API __declspec(dllexport)
  #else
    #define QCOMMANDLINKBUTTON_API __declspec(dllimport)
  #endif
#else
  #define QCOMMANDLINKBUTTON_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QCOMMANDLINKBUTTON_API void* qteQCommandLinkButton_create(void* parent);
QCOMMANDLINKBUTTON_API void  qteQCommandLinkButton_delete(void* w);
QCOMMANDLINKBUTTON_API void* qteQCommandLinkButton_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QCOMMANDLINKBUTTON_API void* qteQCommandLinkButton_description(void* _obj);
QCOMMANDLINKBUTTON_API void qteQCommandLinkButton_setDescription(void* _obj, void* description);

// ── Event handler ────────────────────────────────────────────────────────────
QCOMMANDLINKBUTTON_API void qteQCommandLinkButton_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
