import { useState } from 'react'
import { openAboutWindow, toggleDevtools } from './electronAPI'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div className="App">
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
      </div>
      <button onClick={openAboutWindow}>openAboutWindow</button>
      <button onClick={toggleDevtools}>toggleDevtools</button>
    </div>
  )
}

export default App
