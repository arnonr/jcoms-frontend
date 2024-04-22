import ApiService from "@/core/services/ApiService";

export default () => {
  const fetchComplaintChannel = async () => {
    const { data } = await ApiService.query("complaint-channel", {
      params: { perPage: 100 },
    });

    return data.data;
  };

  return {
    fetchComplaintChannel,
  };
};
