import { ref } from "vue";
import { defineStore } from "pinia";
import ApiService from "@/core/services/ApiService";
import JwtService from "@/core/services/JwtService";
import ability from "../services/ability";

// async function fetchAbilities() {
//     // สมมติว่า fetchAbilities จะดึงข้อมูลสิทธิ์จาก API
//     const response = await fetch('/api/abilities');
//     const data = await response.json();

//     const abilities = defineAbilitiesFor(data.abilities);
//     return abilities;
//   }

export interface User {
  name: string;
  surname: string;
  email: string;
  password: string;
  role_id: number;
  token: string;
}

export const useAuthStore = defineStore("auth", () => {
  const errors = ref({});
  const user = ref<User>({} as User);
  const isAuthenticated = ref(!!JwtService.getToken());

  function setAuth(authUser: User) {
    isAuthenticated.value = true;
    user.value = authUser;
    errors.value = {};
    JwtService.saveToken(user.value.token);
  }

  function setError(error: any) {
    errors.value = { ...error };
  }

  function purgeAuth() {
    isAuthenticated.value = false;
    user.value = {} as User;
    errors.value = [];
    JwtService.destroyToken();
  }

  function login(credentials: User) {
    return ApiService.post("user/login", credentials)
      .then(({ data }) => {
        setAuth(data);

        // data.data.abilities
        const userAbilities = [
          { menu: "Dashboard", action: "view" },
          //   { menu: "Dashboard", action: "create" },
          // ... สิทธิ์อื่นๆ
        ];

        ability.update(
          userAbilities.map((a) => ({ action: a.action, subject: a.menu }))
        );

        localStorage.setItem(
          "userData",
          JSON.stringify({
            ...data.data,
          })
        );
        localStorage.setItem("id_token", data.data.token);

        // หลังจากที่ผู้ใช้ล็อกอินสำเร็จ matomo
        const userId = data.data.officer_code; // ดึงค่า USER_ID ของผู้ใช้งานที่ล็อกอิน
        window._paq.push(["setUserId", userId]);
        window._paq.push(["trackPageView"]); // ติดตามการเข้าชมหน้าเว็บ
      })
      .catch(({ response }) => {
        setError(response.data.msg);
      });
  }

  function logout() {
    purgeAuth();
    localStorage.removeItem("userData");
    localStorage.removeItem("id_token");
  }

  function register(credentials: User) {
    return ApiService.post("register", credentials)
      .then(({ data }) => {
        setAuth(data);
      })
      .catch(({ response }) => {
        setError(response.data.errors);
      });
  }

  function forgotPassword(email: string) {
    return ApiService.post("forgot_password", email)
      .then(() => {
        setError({});
      })
      .catch(({ response }) => {
        setError(response.data.errors);
      });
  }

  function verifyAuth() {
    if (JwtService.getToken()) {
    } else {
    }
    // const userData = JSON.parse(localStorage.getItem("userData") || "{}");
    // if (JwtService.getToken()) {
    //   ApiService.setHeader();
    //   ApiService.post("verify_token", { api_token: JwtService.getToken() })
    //     .then(({ data }) => {
    //       setAuth(data);
    //     })
    //     .catch(({ response }) => {
    //       setError(response.data.errors);
    //       purgeAuth();
    //     });
    // } else {
    //   purgeAuth();
    // }
  }

  return {
    errors,
    user,
    isAuthenticated,
    login,
    logout,
    register,
    forgotPassword,
    verifyAuth,
  };
});
