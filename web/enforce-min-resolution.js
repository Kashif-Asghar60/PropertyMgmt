window.addEventListener('resize', () => {
    const minWidth = 1024; // Minimum width in pixels
    const minHeight = 768; // Minimum height in pixels
  
    if (window.innerWidth < minWidth || window.innerHeight < minHeight) {
      window.resizeTo(minWidth, minHeight);
    }
  });
  