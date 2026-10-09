#pragma once

#ifdef _WIN32
  #ifdef QTE56_QMESSAGEBOX_BUILD
    #define QMESSAGEBOX_API __declspec(dllexport)
  #else
    #define QMESSAGEBOX_API __declspec(dllimport)
  #endif
#else
  #define QMESSAGEBOX_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QMESSAGEBOX_API void* qteQMessageBox_create(void* parent);
QMESSAGEBOX_API void  qteQMessageBox_delete(void* w);
QMESSAGEBOX_API void* qteQMessageBox_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QMESSAGEBOX_API void qteQMessageBox_show(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_hide(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_update(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_addButton_pp(void* _obj, void* button, int role);
QMESSAGEBOX_API void* qteQMessageBox_addButton_sp(void* _obj, void* text, int role);
QMESSAGEBOX_API void* qteQMessageBox_addButton_p(void* _obj, int button);
QMESSAGEBOX_API void qteQMessageBox_removeButton(void* _obj, void* button);
QMESSAGEBOX_API int qteQMessageBox_buttonRole(void* _obj, void* button);
QMESSAGEBOX_API void qteQMessageBox_setStandardButtons(void* _obj, int buttons);
QMESSAGEBOX_API int qteQMessageBox_standardButtons(void* _obj);
QMESSAGEBOX_API int qteQMessageBox_standardButton(void* _obj, void* button);
QMESSAGEBOX_API void* qteQMessageBox_button(void* _obj, int which);
QMESSAGEBOX_API void* qteQMessageBox_defaultButton(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_setDefaultButton(void* _obj, int button);
QMESSAGEBOX_API void* qteQMessageBox_escapeButton(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_setEscapeButton(void* _obj, int button);
QMESSAGEBOX_API void* qteQMessageBox_clickedButton(void* _obj);
QMESSAGEBOX_API void* qteQMessageBox_text(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_setText(void* _obj, void* text);
QMESSAGEBOX_API int qteQMessageBox_icon(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_setIcon(void* _obj, int p0);
QMESSAGEBOX_API int qteQMessageBox_textFormat(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_setTextFormat(void* _obj, int format);
QMESSAGEBOX_API void qteQMessageBox_setTextInteractionFlags(void* _obj, int flags);
QMESSAGEBOX_API int qteQMessageBox_textInteractionFlags(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_setCheckBox(void* _obj, void* cb);
QMESSAGEBOX_API void* qteQMessageBox_checkBox(void* _obj);
QMESSAGEBOX_API int qteQMessageBox_information_wsspp(void* _obj, void* parent, void* title, void* text, int buttons, int defaultButton);
QMESSAGEBOX_API int qteQMessageBox_warning_wsspp(void* _obj, void* parent, void* title, void* text, int buttons, int defaultButton);
QMESSAGEBOX_API int qteQMessageBox_critical_wsspp(void* _obj, void* parent, void* title, void* text, int buttons, int defaultButton);
QMESSAGEBOX_API void qteQMessageBox_about(void* _obj, void* parent, void* title, void* text);
QMESSAGEBOX_API void qteQMessageBox_aboutQt(void* _obj, void* parent, void* title);
QMESSAGEBOX_API int qteQMessageBox_information_wssiii(void* _obj, void* parent, void* title, void* text, int button0, int button1, int button2);
QMESSAGEBOX_API int qteQMessageBox_information_wsssssii(void* _obj, void* parent, void* title, void* text, void* button0Text, void* button1Text, void* button2Text, int defaultButtonNumber, int escapeButtonNumber);
QMESSAGEBOX_API int qteQMessageBox_question_wssiii(void* _obj, void* parent, void* title, void* text, int button0, int button1, int button2);
QMESSAGEBOX_API int qteQMessageBox_question_wsssssii(void* _obj, void* parent, void* title, void* text, void* button0Text, void* button1Text, void* button2Text, int defaultButtonNumber, int escapeButtonNumber);
QMESSAGEBOX_API int qteQMessageBox_warning_wssiii(void* _obj, void* parent, void* title, void* text, int button0, int button1, int button2);
QMESSAGEBOX_API int qteQMessageBox_warning_wsssssii(void* _obj, void* parent, void* title, void* text, void* button0Text, void* button1Text, void* button2Text, int defaultButtonNumber, int escapeButtonNumber);
QMESSAGEBOX_API int qteQMessageBox_critical_wssiii(void* _obj, void* parent, void* title, void* text, int button0, int button1, int button2);
QMESSAGEBOX_API int qteQMessageBox_critical_wsssssii(void* _obj, void* parent, void* title, void* text, void* button0Text, void* button1Text, void* button2Text, int defaultButtonNumber, int escapeButtonNumber);
QMESSAGEBOX_API void* qteQMessageBox_buttonText(void* _obj, int button);
QMESSAGEBOX_API void qteQMessageBox_setButtonText(void* _obj, int button, void* text);
QMESSAGEBOX_API void* qteQMessageBox_informativeText(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_setInformativeText(void* _obj, void* text);
QMESSAGEBOX_API void* qteQMessageBox_detailedText(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_setDetailedText(void* _obj, void* text);
QMESSAGEBOX_API void qteQMessageBox_setWindowTitle(void* _obj, void* title);
QMESSAGEBOX_API void qteQMessageBox_setWindowModality(void* _obj, int windowModality);
QMESSAGEBOX_API int qteQMessageBox_exec(void* _obj);
QMESSAGEBOX_API int qteQMessageBox_result(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_setVisible(void* _obj, int visible);
QMESSAGEBOX_API void* qteQMessageBox_sizeHint(void* _obj);
QMESSAGEBOX_API void* qteQMessageBox_minimumSizeHint(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_setSizeGripEnabled(void* _obj, int p0);
QMESSAGEBOX_API int qteQMessageBox_isSizeGripEnabled(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_setModal(void* _obj, int modal);
QMESSAGEBOX_API void qteQMessageBox_setResult(void* _obj, int r);
QMESSAGEBOX_API void qteQMessageBox_open(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_done(void* _obj, int p0);
QMESSAGEBOX_API void qteQMessageBox_accept(void* _obj);
QMESSAGEBOX_API void qteQMessageBox_reject(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QMESSAGEBOX_API void qteQMessageBox_setEventHandler(void* w, int id, void* cb, void* dthis);

// ── question(StandardButtons) — manual addition (generator missed it) ────────
QMESSAGEBOX_API int qteQMessageBox_question_wsspp(void* _obj, void* parent, void* title, void* text, int buttons, int defaultButton);

// ── Lambda-connect (Qt-pointer signals) ─────────────────────────────────────
QMESSAGEBOX_API void qteQMessageBox_connect_buttonClicked(void* w, void* cb, void* dthis);

} // extern "C"
