const SuspensionTips = require('SuspensionTips');
cc.Class({
	extends: require('BaseAnySDKExample'),

	properties: {},

	start: function () {
		if (this.hasSupport()) {
			this.analyticsPlugin = anysdk.agentManager.getAnalyticsPlugin();
		}
	},

	startSession: function () {
		if (!this.analyticsPlugin) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null ');
			return;
		}
		this.analyticsPlugin.startSession();

	},

	stopSession: function () {
		if (!this.analyticsPlugin) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null ');
			return;
		}
		this.analyticsPlugin.stopSession();
	},

	setSessionContinueMillis: function () {
		if (!this.analyticsPlugin) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null ');
			return;
		}
		this.analyticsPlugin.setSessionContinueMillis(100);

	},

	logError: function () {
		if (!this.analyticsPlugin) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null ');
			return;
		}
		this.analyticsPlugin.logError('error', 'errMsg');
	},

	logEvent: function (eventID, paramMap) {
		if (!this.analyticsPlugin) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null ');
			return;
		}
		this.analyticsPlugin.logEvent('error');
		this.analyticsPlugin.logEvent('error', {'errMsg': 'errMsg'});
	},

	logTimedEventBegin: function () {
		if (!this.analyticsPlugin) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null ');
			return;
		}
		this.analyticsPlugin.logTimedEventBegin('errorbegin');
	},

	logTimedEventEnd: function () {
		if (!this.analyticsPlugin) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null ');
			return;
		}
		this.analyticsPlugin.logTimedEventEnd('errorend');
	},

	setAccount: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.setAccount) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or setAccount is not support ');
			return;
		}
		var paramMap = {
			'Account_Id': '123456',
			'Account_Name': 'test',
			'Account_Type': (anysdk.AccountType.ANONYMOUS).toString(),
			'Account_Level': '1',
			'Account_Age': '1',
			'Account_Operate': (anysdk.AccountOperate.LOGIN).toString(),
			'Account_Gender': (anysdk.AccountGender.MALE).toString(),
			'Server_Id': '1'
		};
		this.analyticsPlugin.setAccount(paramMap);
	},

	onChargeRequest: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.onChargeRequest) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or onChargeRequest is not support ');
			return;
		}
		var paramMap = {
			'Order_Id': '123456',
			'Product_Name': 'test',
			'Currency_Amount': '2.0',
			'Currency_Type': 'CNY',
			'Payment_Type': '渠道',
			'Virtual_Currency_Amount': '100'
		};
		this.analyticsPlugin.onChargeRequest(paramMap);
	},

	onChargeOnlySuccess: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.onChargeOnlySuccess) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or onChargeOnlySuccess is not support ');
			return;
		}
		var paramMap = {
			'Order_Id': '123456',
			'Product_Name': 'test',
			'Currency_Amount': '2.0',
			'Currency_Type': '1',
			'Payment_Type': '1',
			'Virtual_Currency_Amount': '100'
		};
		this.analyticsPlugin.onChargeOnlySuccess(paramMap);
	},

	onChargeSuccess: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.onChargeSuccess) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or onChargeSuccess is not support ');
			return;
		}
		this.analyticsPlugin.onChargeSuccess('123456');
	},

	onChargeFail: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.onChargeFail) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or onChargeFail is not support ');
			return;
		}
		var paramMap = {
			'Order_Id': '123456',
			'Fail_Reason': 'test'
		};
		this.analyticsPlugin.onChargeFail(paramMap);
	},

	onPurchase: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.onPurchase) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or onPurchase is not support ');
			return;
		}
		var paramMap = {
			'Item_Id': '123456',
			'Item_Type': 'test',
			'Item_Count': '2',
			'Virtual_Currency': '1',
			'Currency_Type': anysdk.agentManager.getChannelId()
		};
		this.analyticsPlugin.onPurchase(paramMap);
	},

	onUse: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.onUse) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or onUse is not support ');
			return;
		}
		var paramMap = {
			'Item_Id': '123456',
			'Item_Type': 'test',
			'Item_Count': '2',
			'Use_Reason': '1'
		};
		this.analyticsPlugin.onUse(paramMap);
	},

	onReward: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.onReward) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or onReward is not support ');
			return;
		}
		var paramMap = {
			'Item_Id': '123456',
			'Item_Type': 'test',
			'Item_Count': '2',
			'Use_Reason': '1'
		};
		this.analyticsPlugin.onReward(paramMap);
	},

	startLevel: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.startLevel) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or startLevel is not support ');
			return;
		}
		var paramMap = {
			'Level_Id': '123456',
			'Seq_Num': '1'
		};
		this.analyticsPlugin.startLevel(paramMap);
	},

	finishLevel: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.finishLevel) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or finishLevel is not support ');
			return;
		}
		this.analyticsPlugin.finishLevel('123456');
	},

	failLevel: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.failLevel) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or failLevel is not support ');
			return;
		}
		var paramMap = {
			'Level_Id': '123456',
			'Fail_Reason': 'test'
		};
		this.analyticsPlugin.failLevel(paramMap);
	},

	startTask: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.startTask) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or startTask is not support ');
			return;
		}
		var paramMap = {
			'Task_Id': '123456',
			'Task_Type': (anysdk.TaskType.GUIDE_LINE).toString()
		};
		this.analyticsPlugin.startTask(paramMap);
	},

	finishTask: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.finishTask) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or finishTask is not support ');
			return;
		}
		this.analyticsPlugin.finishTask('123456');
	},

	failTask: function () {
		if (!this.analyticsPlugin || !this.analyticsPlugin.failTask) {
			SuspensionTips.init.showTips(' this.analyticsPlugin is null or failTask is not support ');
			return;
		}
		var paramMap = {
			'Task_Id': '123456',
			'Fail_Reason': 'test'
		};
		this.analyticsPlugin.failTask(paramMap);
	}

});
