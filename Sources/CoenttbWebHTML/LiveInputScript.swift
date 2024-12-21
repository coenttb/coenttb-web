//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 15/12/2024.
//

import Foundation
import CoenttbHTML

public struct LiveInputScript: HTML {
    private let formID: String
    private let inputID: String
    private let inputName: String
    
    public init(
        formID: String,
        inputID: String,
        inputName: String
    ) {
        self.formID = formID
        self.inputID = inputID
        self.inputName = inputName
    }
    
    public init (
        formID: String,
        inputID: String
    ) {
        self.formID = formID
        self.inputID = inputID
        self.inputName = inputID
    }
    
    public var body: some HTML {
        script {"""
                document.addEventListener('DOMContentLoaded', function () {
                    const form = document.getElementById('\(formID)');
                    const inputField = document.getElementById('\(inputID)');

                    if (!form || !inputField) {
                        console.error("Form or input field not found.");
                        return;
                    }

                    let originalValue = inputField.value;
                    let updateTimeout;

                    // Prevent form submission
                    form.addEventListener('submit', function (event) {
                        event.preventDefault();
                    });

                    // Add input listener with debounce
                    inputField.addEventListener('input', function () {
                        clearTimeout(updateTimeout);

                        updateTimeout = setTimeout(async function () {
                            const newValue = inputField.value;

                            if (newValue === originalValue) {
                                return;
                            }

                            const requestBody = new URLSearchParams({ \(inputName): newValue }).toString();

                            try {
                                const response = await fetch(form.action, {
                                    method: form.method || 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                        'Accept': 'application/json',
                                    },
                                    body: requestBody,
                                });

                                if (!response.ok) {
                                    throw new Error(`Network response was not ok: ${response.status}`);
                                }

                                const data = await response.json();

                                if (data.success) {
                                    originalValue = data.data.\(inputName);
                                    showMessage('Update successful', true);
                                } else {
                                    throw new Error(data.message || 'Update failed');
                                }
                            } catch (error) {
                                console.error('Error:', error);
                                inputField.value = originalValue;
                                showMessage('An error occurred. Please try again.', false);
                            }
                        }, 1000); // Debounce interval
                    });

                    // Helper to show messages
                    function showMessage(message, isSuccess) {
                        let messageDiv = form.querySelector('#update-message');
                        if (!messageDiv) {
                            messageDiv = document.createElement('div');
                            messageDiv.id = 'update-message';
                            messageDiv.style.textAlign = 'center';
                            messageDiv.style.marginTop = '10px';
                            form.appendChild(messageDiv);
                        }

                        messageDiv.textContent = message;
                        messageDiv.style.color = isSuccess ? 'green' : 'red';

                        setTimeout(() => messageDiv.remove(), 5000);
                    }
                });
                """}
    }
}
