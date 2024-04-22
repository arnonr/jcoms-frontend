import ApiService from "@/core/services/ApiService";

export default () => {
  const fetchPrefixName = async () => {
    const { data } = await ApiService.query("prefix-name", {
      params: { perPage: 100 },
    });

    return data.data;
  };

  return {
    fetchPrefixName,
  };
};
