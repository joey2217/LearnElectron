import { useState } from 'react'
import './App.css'

function App() {
  const [count, setCount] = useState(0)
  const [value, setValue] = useState('')

  const onClick = () => {
    window.electronAPI.sendMessageToMain(value)
  }

  return (
    <div className="App">
      <h1>About</h1>
      <div>
        <input value={value} onChange={(e) => setValue(e.target.value)} />
        <button onClick={onClick}>send to main</button>
      </div>
      <div>
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <button onClick={() => window.devAPI.toggleDevtools()}>
          toggleDevtools
        </button>
      </div>
    </div>
  )
}

export default App
