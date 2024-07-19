import { ref, onMounted, onUnmounted } from "vue";

export function useUserInactivity(timeout = 1800000) {
  // Default 30 minutes
  const isInactive = ref(false);
  let inactivityTimer;

  const resetTimer = () => {
    clearTimeout(inactivityTimer);
    isInactive.value = false;
    inactivityTimer = setTimeout(() => {
      isInactive.value = true;
    }, timeout);
  };

  const setupListeners = () => {
    ["mousedown", "mousemove", "keypress", "scroll", "touchstart"].forEach(
      (eventName) => document.addEventListener(eventName, resetTimer, true)
    );
  };

  const cleanupListeners = () => {
    ["mousedown", "mousemove", "keypress", "scroll", "touchstart"].forEach(
      (eventName) => document.removeEventListener(eventName, resetTimer, true)
    );
    clearTimeout(inactivityTimer);
  };

  onMounted(() => {
    setupListeners();
    resetTimer();
  });

  onUnmounted(() => {
    cleanupListeners();
  });

  return { isInactive };
}
