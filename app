'use client';

import { useState, useEffect } from 'react';

interface User {
  email: string;
  subscribed: boolean;
}

export default function XionBot() {
  const [user, setUser] = useState<User | null>(null);
  const [showLogin, setShowLogin] = useState(false);
  const [showPayment, setShowPayment] = useState(false);
  const [isLoginMode, setIsLoginMode] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState('');

  useEffect(() => {
    const saved = localStorage.getItem('xionUser');
    if (saved) setUser(JSON.parse(saved));
  }, []);

  const saveUser = (newUser: User) => {
    localStorage.setItem('xionUser', JSON.stringify(newUser));
    setUser(newUser);
  };

  const handleAuth = () => {
    if (!email || !password) return setMessage("Please fill all fields");

    if (isLoginMode) {
      const saved = localStorage.getItem('xionUser');
      if (saved) {
        const existing = JSON.parse(saved);
        if (existing.email === email) {
          setUser(existing);
          setMessage("Login successful!");
          setTimeout(() => setShowLogin(false), 800);
        } else setMessage("Account not found");
      }
    } else {
      saveUser({ email, subscribed: false });
      setMessage("Account created! Now login.");
      setIsLoginMode(true);
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('xionUser');
    setUser(null);
  };

  const confirmPayment = () => {
    if (!user) return;
    const updated = { ...user, subscribed: true };
    saveUser(updated);
    setShowPayment(false);
    setMessage("✅ Payment confirmed! Full access unlocked.");
  };

  return (
    <div className="min-h-screen bg-gray-950 text-white">
      {/* Navbar */}
      <nav className="border-b border-gray-800 bg-gray-900 sticky top-0 z-50">
        <div className="max-w-6xl mx-auto px-6 py-4 flex justify-between items-center">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-gradient-to-br from-purple-500 to-blue-500 rounded-2xl flex items-center justify-center text-2xl font-bold">X</div>
            <h1 className="text-2xl font-bold">Xion-Bot</h1>
          </div>

          <div className="flex items-center gap-6 text-sm">
            <a href="#courses" className="hover:text-purple-400">Courses</a>
            <a href="#pricing" className="hover:text-purple-400">Pricing</a>

            {user ? (
              <div className="flex items-center gap-4">
                <span className="text-gray-400 text-sm">{user.email.split('@')[0]}</span>
                {user.subscribed && <span className="text-green-400">✓ Full Access</span>}
                <button onClick={handleLogout} className="text-red-400 hover:underline">Logout</button>
              </div>
            ) : (
              <button onClick={() => {setShowLogin(true); setIsLoginMode(true);}} className="bg-purple-600 hover:bg-purple-700 px-5 py-2 rounded-xl">
                Login
              </button>
            )}
          </div>
        </div>
      </nav>

      {/* Hero */}
      <section className="py-24 text-center px-6">
        <h2 className="text-5xl md:text-6xl font-bold mb-6">Learn Coding & Website Development<br />The <span className="text-purple-400">Easy Way</span></h2>
        <p className="text-xl text-gray-400 max-w-2xl mx-auto">Step-by-step lessons from zero to building real websites. No confusing jargon.</p>
        {!user && (
          <button onClick={() => {setShowLogin(true); setIsLoginMode(false);}} className="mt-10 bg-purple-600 hover:bg-purple-700 px-10 py-4 rounded-2xl text-lg font-semibold">
            Start Learning Free
          </button>
        )}
      </section>

      {/* Free Previews */}
      <section id="courses" className="max-w-6xl mx-auto px-6 py-16 border-t border-gray-800">
        <h3 className="text-3xl font-semibold mb-10 text-center">Free Preview Lessons</h3>
        <div className="grid md:grid-cols-3 gap-6">
          {[
            ["HTML Basics", "Structure any webpage"],
            ["CSS & Styling", "Make beautiful designs"],
            ["JavaScript", "Add interactivity"]
          ].map(([title, desc], i) => (
            <div key={i} className="bg-gray-900 p-8 rounded-3xl border border-gray-800 hover:border-purple-500 transition-all">
              <h4 className="text-xl font-semibold mb-3">{title}</h4>
              <p className="text-gray-400">{desc}</p>
              <button className="mt-6 text-purple-400 hover:underline">Read Preview →</button>
            </div>
          ))}
        </div>
      </section>

      {/* Pricing */}
      <section id="pricing" className="bg-gray-900 py-20">
        <div className="max-w-4xl mx-auto px-6 text-center">
          <h3 className="text-4xl font-bold mb-4">One-Time Payment</h3>
          <p className="text-6xl font-bold text-purple-400 mb-2">₦3,000</p>
          <p className="text-gray-400 mb-10">Lifetime Access • All Lessons + Projects</p>

          {user ? (
            user.subscribed ? (
              <div className="text-green-400 text-3xl font-semibold">🎉 You have full lifetime access!</div>
            ) : (
              <button onClick={() => setShowPayment(true)} className="bg-white text-black hover:bg-gray-200 px-12 py-5 rounded-2xl text-xl font-semibold">
                Pay ₦3,000 Now
              </button>
            )
          ) : (
            <p className="text-gray-400">Please login or register to purchase</p>
          )}
        </div>
      </section>

      {/* Full Course - Only after payment */}
      {user?.subscribed && (
        <section className="max-w-6xl mx-auto px-6 py-20">
          <h3 className="text-3xl font-bold mb-12 text-center">Full Course Curriculum</h3>
          <div className="space-y-6">
            {[
              "1. HTML5 & Semantic Markup",
              "2. CSS3, Flexbox & Grid",
              "3. Responsive Design (Mobile Friendly)",
              "4. JavaScript ES6+ Fundamentals",
              "5. Building Real Projects (Portfolio, Landing Page, etc.)",
              "6. Introduction to React & Next.js",
              "7. Hosting on Vercel / Netlify",
              "8. Git, GitHub & Best Practices"
            ].map((item, i) => (
              <div key={i} className="flex gap-4 bg-gray-900 p-6 rounded-2xl border-l-4 border-purple-500">
                <span className="text-purple-400 text-2xl">✓</span>
                <p className="text-lg">{item}</p>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* Login Modal */}
      {showLogin && (
        <div className="fixed inset-0 bg-black/90 flex items-center justify-center z-50 p-4">
          <div className="bg-gray-900 p-8 rounded-3xl max-w-md w-full">
            <h3 className="text-2xl font-bold mb-6">{isLoginMode ? "Login" : "Create Account"}</h3>

            <input type="email" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)}
              className="w-full bg-gray-800 border border-gray-700 rounded-xl px-5 py-4 mb-4" />
            <input type="password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)}
              className="w-full bg-gray-800 border border-gray-700 rounded-xl px-5 py-4 mb-6" />

            {message && <p className="text-center text-green-400 mb-4">{message}</p>}

            <button onClick={handleAuth} className="w-full bg-purple-600 hover:bg-purple-700 py-4 rounded-2xl font-semibold mb-4">
              {isLoginMode ? "Login" : "Register"}
            </button>

            <button onClick={() => {setIsLoginMode(!isLoginMode); setMessage('');}} className="w-full text-sm text-gray-400 hover:text-white">
              {isLoginMode ? "Need an account? Register" : "Already have account? Login"}
            </button>

            <button onClick={() => setShowLogin(false)} className="mt-6 text-gray-500 hover:text-gray-300 w-full">Close</button>
          </div>
        </div>
      )}

      {/* Payment Modal */}
      {showPayment && (
        <div className="fixed inset-0 bg-black/90 flex items-center justify-center z-50 p-4">
          <div className="bg-gray-900 p-8 rounded-3xl max-w-md w-full">
            <h3 className="text-2xl font-bold mb-6">Pay ₦3,000</h3>
            <div className="bg-gray-800 rounded-2xl p-6 mb-8 space-y-2">
              <p><strong>Bank:</strong> Kuda Bank</p>
              <p><strong>Account Number:</strong> 2086686536</p>
              <p><strong>Amount:</strong> ₦3,000</p>
              <p className="text-xs text-yellow-400">After paying, click the button below to activate access</p>
            </div>

            <button onClick={confirmPayment} className="w-full bg-green-600 hover:bg-green-700 py-4 rounded-2xl font-semibold mb-4">
              I Have Paid – Unlock Full Course
            </button>

            <button onClick={() => setShowPayment(false)} className="w-full text-gray-400">Cancel</button>
          </div>
        </div>
      )}

      <footer className="text-center py-12 text-gray-500 border-t border-gray-800">
        Xion-Bot © 2026 • Learn Coding The Easy Way
      </footer>
    </div>
  );
}
