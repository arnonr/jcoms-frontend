// src/stores/useSearchStore.ts
import { defineStore } from "pinia";
import { ref } from "vue";
import ApiService from "@/core/services/ApiService";

interface Search {
  year: number | null;
  complaint_title: string;
  jcoms_no: string;
  complainant_fullname: string;
  accused_fullname: string;
  bureau_id: number | null;
  division_id: number | null;
  agency_id: number | null;
}

export const useSearchComplaintStore = defineStore("search", () => {
  const search = ref<Search>({
    year: null,
    complaint_title: "",
    jcoms_no: "",
    complainant_fullname: "",
    accused_fullname: "",
    bureau_id: null,
    division_id: null,
    agency_id: null,
  });

  const setSearch = (newSearch: Partial<Search>) => {
    search.value = { ...search.value, ...newSearch };
  };

  const fetchPrefixName = async (params: any) => {
    const { data } = await ApiService.query("prefix-name", {
      params: params,
    });

    return data.data;
  };

  const fetchState = async (params: any) => {
    const { data } = await ApiService.query("state", {
      params: params,
    });
    return data.data
  };

  const fetchInspector = async (params: any) => {
    const { data } = await ApiService.query("inspector", {
      params: params,
    });
    return data.data;
  };

  const fetchBureau = async (params: any) => {
    const { data } = await ApiService.query("bureau", {
      params: params,
    });
    return data.data;
  };

  const fetchDivision = async (params: any) => {
    const { data } = await ApiService.query("division", {
      params: params,
    });
    return data.data;
  };

  const fetchAgency = async (params: any) => {
    const { data } = await ApiService.query("agency", {
      params: params,
    });
    return data.data;
  };

  const fetchProvince = async (params: any) => {
    const { data } = await ApiService.query("province", {
      params: params,
    });
    return data.data;
  };

  const fetchDistrict = async (params: any) => {
    const { data } = await ApiService.query("district", {
      params: params,
    });
    return data.data;
  };

  const fetchSubdistrict = async (params: any) => {
    const { data } = await ApiService.query("sub-district", {
      params: params,
    });
    return data.data;
  };

  const fetchComplaintType = async (params: any) => {
    const { data } = await ApiService.query("complaint-type", {
      params: params,
    });
    return data.data;
  };

  const fetchTopicCategory = async (params: any) => {
    const { data } = await ApiService.query("topic-category", {
      params: params,
    });
    return data.data;
  };

  const fetchTopicType = async (params: any) => {
    const { data } = await ApiService.query("topic-type", {
      params: params,
    });
    return data.data;
  };

  const fetchComplaintChannel = async (params: any) => {
    const { data } = await ApiService.query("complaint-channel", {
      params: params,
    });
    return data.data;
  };

  const clearSearch = () => {
    search.value = {
      year: null,
      complaint_title: "",
      jcoms_no: "",
      complainant_fullname: "",
      accused_fullname: "",
      bureau_id: null,
      division_id: null,
      agency_id: null,
    };
  };

  return {
    search,
    setSearch,
    clearSearch,
    fetchPrefixName,
    fetchState,
    fetchInspector,
    fetchProvince,
    fetchComplaintType,
    fetchComplaintChannel,
    fetchBureau,
    fetchDivision,
    fetchAgency,
    fetchDistrict,
    fetchSubdistrict,
    fetchTopicCategory,
    fetchTopicType,
  };
});
