import React, { useRef, useEffect } from 'react';
import * as d3 from 'd3';

const ClickbaitChart = ({ score }) => {
  const ref = useRef();

  useEffect(() => {
    const width = 200;
    const height = 200;
    const radius = Math.min(width, height) / 2;
    const innerRadius = radius - 20;
    const svg = d3.select(ref.current)
      .attr('width', width)
      .attr('height', height);

    // Gradient tanımlama
    const defs = svg.append("defs");
    const gradient = defs.append("linearGradient")
      .attr("id", "gradient")
      .attr("x1", "0%")
      .attr("x2", "100%")
      .attr("y1", "0%")
      .attr("y2", "100%");
    gradient.append("stop")
      .attr("offset", "0%")
      .attr("stop-color", "#4caf50");
      
    gradient.append("stop")
      .attr("offset", "50%")
      .attr("stop-color", "#ffeb3b");
    gradient.append("stop")
      .attr("offset", "100%")
      .attr("stop-color", "#f44336");
      

    const arc = d3.arc()
      .innerRadius(innerRadius)
      .outerRadius(radius)
      .startAngle(0)
      .endAngle((2 * Math.PI) * score);

    const g = svg.append('g')
      .attr('transform', `translate(${width / 2}, ${height / 2})`);

    // Background arc
    g.append('path')
      .datum({ endAngle: 2 * Math.PI })
      .attr('d', d3.arc()
        .innerRadius(innerRadius)
        .outerRadius(radius)
      )
      .style('fill', '#eee');

    // Foreground arc
    g.append('path')
      .datum({ endAngle: (2 * Math.PI) * score })
      .attr('d', arc)
      .style('fill', 'url(#gradient)');

    // Değeri ortada gösterme
    g.append('text')
      .attr('text-anchor', 'middle')
      .attr('dy', '.35em')
      .style('font-size', '24px')
      .style('fill', '#333')
      .text(`${Math.round(score * 100)}%`);

    // Temizleme
    return () => {
      svg.selectAll('*').remove();
    };
  }, [score]);

  return <svg ref={ref}></svg>;
};

export default ClickbaitChart;
