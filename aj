import pyautogui
import keyboard
import time
import sys
import platform

pyautogui.FAILSAFE = True
pyautogui.PAUSE = 0

positions = [None, None, None]

# Caret (I-Beam) cursor fix (Windows only)
if platform.system() == "Windows":
    import ctypes
    import ctypes.wintypes

    user32 = ctypes.WinDLL('user32', use_last_error=True)

    IDC_ARROW = 32512
    IDC_IBEAM = 32513
    HCURSOR = ctypes.c_void_p

    class POINT(ctypes.Structure):
        _fields_ = [('x', ctypes.c_long), ('y', ctypes.c_long)]

    class CURSORINFO(ctypes.Structure):
        _fields_ = [
            ('cbSize', ctypes.wintypes.DWORD),
            ('flags', ctypes.wintypes.DWORD),
            ('hCursor', HCURSOR),
            ('ptScreenPos', POINT)
        ]

    def get_cursor_id():
        ci = CURSORINFO()
        ci.cbSize = ctypes.sizeof(CURSORINFO)
        if not user32.GetCursorInfo(ctypes.byref(ci)):
            raise ctypes.WinError(ctypes.get_last_error())
        return ci.hCursor

    hArrow = user32.LoadCursorW(None, IDC_ARROW)
    hIBeam = user32.LoadCursorW(None, IDC_IBEAM)

    def fix_caret_cursor():
        if get_cursor_id() == hIBeam:
            user32.SetCursor(hArrow)
else:
    def fix_caret_cursor():
        pass

def perform_actions():
    if None in positions:
        print("❌ Save all 3 slots first (1, 2, 3).")
        return

    paste_keys = ('command', 'v') if platform.system() == 'Darwin' else ('ctrl', 'v')

    try:
        # Slot 1: Double click + paste + delay 0.5
        pyautogui.moveTo(positions[0])
        pyautogui.click(clicks=2, interval=0.01)
        pyautogui.hotkey(*paste_keys)
        time.sleep(0.5)

        # Slot 2: Double click + delay 0.8
        pyautogui.moveTo(positions[1])
        pyautogui.click(clicks=2, interval=0.01)
        time.sleep(0.8)

        # Slot 3: Spam click for 1 second
        pyautogui.moveTo(positions[2])
        fix_caret_cursor()
        end_time = time.time() + 1.0
        while time.time() < end_time:
            pyautogui.click()

        print("✅ Actions completed.")
    except Exception as e:
        print(f"❗ Error: {e}")

def main():
    print("🖱 Press 1 to save Slot 1 (double click + paste + 0.5s)")
    print("🖱 Press 2 to save Slot 2 (double click + 0.8s)")
    print("🖱 Press 3 to save Slot 3 (spam click for 1s)")
    print("🔄 Press R to reset all slots")
    print("▶ Press Enter to run actions")
    print("❌ Press Esc to quit\n")

    try:
        while True:
            if keyboard.is_pressed('1'):
                positions[0] = pyautogui.position()
                print(f"📍 Slot 1 saved at {positions[0]}")
                while keyboard.is_pressed('1'): pass

            if keyboard.is_pressed('2'):
                positions[1] = pyautogui.position()
                print(f"📍 Slot 2 saved at {positions[1]}")
                while keyboard.is_pressed('2'): pass

            if keyboard.is_pressed('3'):
                positions[2] = pyautogui.position()
                print(f"📍 Slot 3 saved at {positions[2]}")
                while keyboard.is_pressed('3'): pass

            if keyboard.is_pressed('r'):
                positions[:] = [None, None, None]
                print("🔄 Slots reset.")
                while keyboard.is_pressed('r'): pass

            if keyboard.is_pressed('enter'):
                perform_actions()
                while keyboard.is_pressed('enter'): pass

            if keyboard.is_pressed('esc'):
                print("👋 Exiting script.")
                break

            time.sleep(0.05)

    except Exception as e:
        print(f"❗ Script crashed: {e}")
    finally:
        print("🛑 Script terminated.")

if __name__ == "__main__":
    try:
        import pyautogui
        import keyboard
    except ImportError:
        print("📦 Install dependencies with:")
        print("pip install pyautogui keyboard")
        sys.exit(1)

    main()
