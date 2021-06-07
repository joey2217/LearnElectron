import React, { useEffect } from 'react'
import { ipcRenderer } from 'electron'
import { GlobalStyle } from './styles/GlobalStyle'
import Greetings from './components/Greetings'
import IpcEvents from '../common/ipcEvents'

const App: React.FC = () => {
  useEffect(() => {
    ipcRenderer.invoke(IpcEvents.HELLO, 'hello')
  }, [])
  return (
    <>
      <GlobalStyle />
      <Greetings />
    </>
  )
}

export default App
