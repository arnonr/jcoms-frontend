import ApiService from "@/core/services/ApiService";

export default () => {
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
    return data.data.filter((x: any) => {
      return x.id == 1 || x.id == 18;
    });
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

  return {
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
};
