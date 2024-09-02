import React, { useState, useEffect, useContext } from 'react';
import ClickbaitChart from '../ClickbaitChart';
import { CableContext } from '../../context/cable';

import '../../assets/stylesheets/app/style.css';

const App = () => {
  const [inputUrl, setInputUrl] = useState('');
  const [requestId, setRequestId] = useState('');
  const [evaluationResult, setEvaluationResult] = useState(null);
  const [title, setTitle] = useState(null);
  const [clickBaitScore, setClickBaitScore] = useState(null);
  const [loading, setLoading] = useState(false);
  const cableContext = useContext(CableContext)

  useEffect(() => {
    const callbackChannel = cableContext.cable.subscriptions.create({
      channel: 'CallbackChannel',
    },{
      connected: () => callbackChannel.send({ type: 'configuration::get' }),
      received: (data) => console.log(data)
    });
  }, []);

  const handleInputChange = (event) => {
    setInputUrl(event.target.value);
  };

  const handleSubmit = async () => {
    setLoading(true);
    try {
      const response = await fetch(`https://api.v1.debunker-assistant.aequa-tech.com/internal/v1/scrape?inputUrl=${encodeURIComponent(inputUrl)}&language=en&retry=false&maxRetries=5&timeout=10&maxChars=10000`, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
        },
      });
      const data = await response.json();
      setRequestId(data.request_id);

      const evaluationResponse = await fetch(`https://api.v1.debunker-assistant.aequa-tech.com/internal/v1/evaluation?language=en&request_id=${data.request_id}`, {
        method: 'GET',
        headers: {
          'Accept': 'application/json',
        },
      });
      const evaluationData = await evaluationResponse.json();
      setEvaluationResult(evaluationData);

      if (evaluationData && evaluationData.clickBait && evaluationData.clickBait.overallScore) {
        setClickBaitScore(evaluationData.clickBait.overallScore.content); // 0-1 arasında
      }

      const newApiResponse = await fetch(`https://api.v1.debunker-assistant.aequa-tech.com/internal/v1/internal/scrape?inputUrl=${encodeURIComponent(inputUrl)}&language=en`, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
        },
      });
      const newApiData = await newApiResponse.json();
      setTitle(newApiData.result.title);
    } catch (error) {
      console.error('Error fetching the API', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>Trying out APIs</h1>
        <input
          type="text"
          value={inputUrl}
          onChange={handleInputChange}
          placeholder="Enter URL"
        />
        <button onClick={handleSubmit} disabled={loading}>
          {loading ? 'Loading...' : 'Submit'}
        </button>
        {requestId && <p>Request ID: {requestId}</p>}
        {title && (
          <div className="title-box">
            <h2>Title Information</h2>
            <p>{title}</p>
          </div>
        )}
        {clickBaitScore !== null && (
          <div className="clickbait-box">
            <h2>Clickbait Score</h2>
            <ClickbaitChart score={clickBaitScore} />
          </div>
        )}
        {evaluationResult && (
          <div className="content-box">
            <h2>Evaluation Result</h2>
            <pre>{JSON.stringify(evaluationResult, null, 2)}</pre>
          </div>
        )}
      </header>
    </div>
  );
}

export default App;
