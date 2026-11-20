package com.ehaquesoft.ngo

import android.annotation.SuppressLint
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

class ActivityForResult : AppCompatActivity() {
    @SuppressLint("MissingInflatedId")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_for_result)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        val message = intent.getStringExtra("message")
        findViewById<TextView>(R.id.tv_message_from_flutter).text = message

        val button = findViewById<Button>(R.id.btn_send)
        val editText = findViewById<EditText>(R.id.et_message)

        button.setOnClickListener {
            val message = editText.text.toString()
            if(message.isEmpty()){
                editText.error = "Please enter a message"
                editText.requestFocus()
                return@setOnClickListener
            }
            val intent = intent
            intent.putExtra("message", message)
            setResult(RESULT_OK, intent)
            finish()
        }
    }

}