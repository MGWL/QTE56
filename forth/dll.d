import core.sys.windows.windows;
import core.sys.windows.dll;
import core.runtime;     // Загрузка DLL Для Win
 
__gshared HINSTANCE g_hInst;
 
extern (Windows)
BOOL DllMain(HINSTANCE hInstance, ULONG ulReason, LPVOID pvReserved)
{
    switch (ulReason)
    {
	case DLL_PROCESS_ATTACH:
	    g_hInst = hInstance;
		// MessageBoxA(null, "++Star process. On GC".ptr, "Warning!!!".ptr, MB_OK);
	    dll_process_attach( hInstance, true );
	    break;
	case DLL_PROCESS_DETACH:
		// MessageBoxA(null, "--Stop process. Off GC".ptr, "Warning!!!".ptr, MB_OK);
	    dll_process_detach( hInstance, true );
	    break;
	case DLL_THREAD_ATTACH:
		// MessageBoxA(null, "+star thred.".ptr, "Warning!!!".ptr, MB_OK);
	    dll_thread_attach( true, true );
	    break;
	case DLL_THREAD_DETACH:
		// MessageBoxA(null, "-stop thred.".ptr, "Warning!!!".ptr, MB_OK);
	    dll_thread_detach( true, true );
	    break;
        default:
    }
    return true;
}