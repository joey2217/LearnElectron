import { useEffect, useState } from 'react'
import { openAboutWindow, toggleDevtools, onMessage } from './electronAPI'
import './App.css'

function App() {
  const [count, setCount] = useState(0)
  const [message, setMessage] = useState('')
  useEffect(() => {
    onMessage(setMessage)
  }, [])
  return (
    <div className="App">
      <h1>Home</h1>
      <div className="card">
        <div>
          <h2>message from about</h2>
          <div>{message}</div>
        </div>
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
