import { createStore } from "vuex";

export default createStore({
  state: {
    area: "",
  },
  mutations: {
    UPDATE_AREA: (state, area) => {
      state.area = area;
    },
  },
});
