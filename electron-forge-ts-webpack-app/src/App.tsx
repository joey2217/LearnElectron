import React, { FC } from "react";
import ReactDOM from "react-dom";

const App: FC = () => {
  return (
    <div className="app">
      <p>APP</p>
      <p>APP</p>
    </div>
  );
};

ReactDOM.render(<App />, document.getElementById("root"));
