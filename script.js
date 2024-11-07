document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('expense-form');
    const expensesList = document.getElementById('expenses-list');
    form.addEventListener('submit', function (event) {
        event.preventDefault(); // Prevent the form from submitting via the browser
        const description = document.getElementById('description').value;
        const amount = document.getElementById('amount').value;
        const date = document.getElementById('date').value;
        const category = document.getElementById('category').value;
        addExpense(description, amount, date, category);
        form.reset(); // Reset the form fields after submitting
    });
    function addExpense(description, amount, date, category) {
        const expenseDiv = document.createElement('div');
        expenseDiv.classList.add('expense');
        const expenseDetails = `
                <p>Description: ${description}</p>
                <p>Amount: $${parseFloat(amount).toFixed(2)}</p>
                <p>Date: ${date}</p>
                <p>Category: ${category}</p>
        `;
        expenseDiv.innerHTML = expenseDetails;
        expensesList.appendChild(expenseDiv);
    }
    function summarizeExpenses(expenses) {
        const summaryByCategory = expenses.reduce((acc, curr) => {
            if (!acc[curr.category]) acc[curr.category] = 0;
            acc[curr.category] += curr.amount;
            return acc;
        }, {});
        const totalExpenses = expenses.reduce((acc, curr) => acc + curr.amount, 0);
        console.log("Summary by Category:", summaryByCategory);
        console.log("Total Expenses:", totalExpenses);
        })
    }
});
