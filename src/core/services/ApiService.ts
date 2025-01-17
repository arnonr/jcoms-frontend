import type { App } from "vue";
import type { AxiosResponse } from "axios";
import axios from "axios";
import VueAxios from "vue-axios";
import JwtService from "@/core/services/JwtService";

/**
 * @description service to call HTTP request via Axios
 */
class ApiService {
  /**
   * @description property to share vue instance
   */
  public static vueInstance: App;

  /**
   * @description initialize vue axios
   */
  public static init(app: App<Element>) {
    ApiService.vueInstance = app;
    ApiService.vueInstance.use(VueAxios, axios);
    ApiService.vueInstance.axios.defaults.baseURL =
      import.meta.env.VITE_APP_API_URL;
  }

  /**
   * @description set the default HTTP request headers
   */  
  public static setHeader(): void {
    ApiService.vueInstance.axios.defaults.headers.common[
      "Authorization"
        ] = `Bearer 53e4883a6980251c56e977a5624618a0e4a57472615a0af7c374832a8efbab46`;
        ApiService.vueInstance.axios.defaults.headers.common["Accept"] =
        "application/json";
    }

  /**
   * @description send the GET HTTP request
   * @param resource: string
   * @param params: AxiosRequestConfig
   * @returns Promise<AxiosResponse>
   */
  public static query(resource: string, params: any): Promise<AxiosResponse> {
    ApiService.setHeader();
    return ApiService.vueInstance.axios.get(resource, params);
  }

  /**
   * @description send the GET HTTP request
   * @param resource: string
   * @param slug: string
   * @returns Promise<AxiosResponse>
   */
  public static get(
    resource: string,
    slug = "" as string
  ): Promise<AxiosResponse> {
    ApiService.setHeader();
    return ApiService.vueInstance.axios.get(`${resource}/${slug}`);
  }

  /**
   * @description set the POST HTTP request
   * @param resource: string
   * @param params: AxiosRequestConfig
   * @returns Promise<AxiosResponse>
   */
  public static post(resource: string, params: any): Promise<AxiosResponse> {
    ApiService.setHeader();
    return ApiService.vueInstance.axios.post(`${resource}`, params);
  }

  public static postFormData(
    resource: string,
    params: any
  ): Promise<AxiosResponse> {
    // var form_data = new FormData();
    // for (var key in params) {
    //   form_data.append(key, params[key]);
    //   if (params[key] == null || params[key] == "") {
    //     params[key] = null;
    //   }
    // }

    const formData = new FormData();
    Object.keys(params).forEach((key) => {
      formData.append(key, params[key]);
    });

    ApiService.setHeader();
    // formData
    return ApiService.vueInstance.axios.post(`${resource}`, params, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
  }

  /**
   * @description send the UPDATE HTTP request
   * @param resource: string
   * @param slug: string
   * @param params: AxiosRequestConfig
   * @returns Promise<AxiosResponse>
   */
  public static update(
    resource: string,
    slug: string,
    params: any
  ): Promise<AxiosResponse> {
    ApiService.setHeader();
    return ApiService.vueInstance.axios.put(`${resource}/${slug}`, params);
  }

  /**
   * @description Send the PUT HTTP request
   * @param resource: string
   * @param params: AxiosRequestConfig
   * @returns Promise<AxiosResponse>
   */
  public static put(resource: string, params: any): Promise<AxiosResponse> {
    ApiService.setHeader();
    return ApiService.vueInstance.axios.put(`${resource}`, params);
  }

  public static putFormData(
    resource: string,
    params: any
  ): Promise<AxiosResponse> {
    ApiService.setHeader();

    const formData = new FormData();
    Object.keys(params).forEach((key) => {
      formData.append(key, params[key]);
    });

    console.log(params);
    return ApiService.vueInstance.axios.post(`${resource}`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
  }

  /**
   * @description Send the DELETE HTTP request
   * @param resource: string
   * @returns Promise<AxiosResponse>
   */
  public static delete(resource: string): Promise<AxiosResponse> {
    ApiService.setHeader();
    return ApiService.vueInstance.axios.delete(resource);
  }
}

export default ApiService;
