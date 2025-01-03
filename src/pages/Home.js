import React from 'react';
import { Button, Container, Typography, Box } from '@mui/material';
import '../styles/Home.css';

function Home() {
  return (
    <Container maxWidth="sm" className="home-container">
      <Box 
        sx={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          minHeight: '100vh',
          gap: 3
        }}
      >
        <Typography variant="h2" component="h1" gutterBottom>
          Front Desk Control
        </Typography>
        
        <Box sx={{ display: 'flex', gap: 2 }}>
          <Button 
            variant="contained" 
            color="primary" 
            size="large"
            href="/register"
          >
            Register
          </Button>
          <Button 
            variant="outlined" 
            color="primary" 
            size="large"
            href="/login"
          >
            Login
          </Button>
        </Box>
      </Box>
    </Container>
  );
}

export default Home;
