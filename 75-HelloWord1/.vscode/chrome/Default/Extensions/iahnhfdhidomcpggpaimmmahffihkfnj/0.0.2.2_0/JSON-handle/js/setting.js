

var config = {
	mode : 'request'
};




JH.request = JH.newFun(function ($) {
	var _fun = function (oSrc) {
		var _oSrc = oSrc, _oRequestData, _oResponseData;

		//JH.modNS.jsonH.language = 'zh-cn';
		return {
			"create" : function (ns, sKey, oSpec) {
				var oRe;
				var buildSend = function (fn) {
					return {
						send : function (oRequestData) {
							fn(oRequestData, function (oData) {
								if(oSpec && oSpec.succeed) {
									oSpec.succeed.apply(_oSrc, [oData, oRequestData]);
								}
							});
						}
					};
				};

				switch(sKey) {
					case 'getJsonString':
						oRe = buildSend(function (oRequestData, fResponse) {
							chrome.extension.sendRequest({cmd:'getJson'}, function(response) {
								var oData = {
									code : 1,
									msg : 'ok',
									data : response
								};
								fResponse(oData);
							});
						});
						break;
					case 'setIni':
						oRe = buildSend(function (oRequestData, fResponse) {
							chrome.extension.sendRequest({
								cmd:'setIni'
								, oIni : oRequestData
							}, function(response) {
								var oData = {
									code : 1,
									msg : 'ok',
									data : response
								};
								fResponse(oData);
							});
						});
						break;
					
				}

				return oRe;

			}
		};
	};

	return $.mergePropertyFrom(_fun, {
		"NS" : {
			'jsonH' : {}
		}
	});
});

parseHTML = {};
parseHTML.s = ['inner'];




JH["elementHtml"] = function (el, sHtml) {
	var s = parseHTML.s.concat(['HTM']).join('');
	if(sHtml !== undefined) {
		//parseHTML(document, sHtml, true, 'chrome://jsonhandle/content/JSON-handle/JSON-handle.html', false);
		el[s+'L'] = sHtml;
		return el;
	}else{
		return el[s+'L'];
	}
};











