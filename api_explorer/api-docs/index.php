<?php 
echo '{
    "apiVersion": "1.0.0",
    "swaggerVersion": "1.2",
    "apis": [
		{
            "path": "users.json",
            "description": "Operations about Users"
        },
		{
            "path": "boards.json",
            "description": "Operations about Boards"
        },
		{
            "path": "lists.json",
            "description": "Operations about Lists"
        },
		{
            "path": "cards.json",
            "description": "Operations about Cards"
        },
		{
            "path": "card_voters.json",
            "description": "Operations about Card voters"
        },
		{
            "path": "cards_labels.json",
            "description": "Operations about Card labels"
        },
		{
            "path": "card_attachments.json",
            "description": "Operations about Card attachments"
        },
		{
            "path": "comments.json",
            "description": "Operations about Card comments"
        },
		{
            "path": "checklists.json",
            "description": "Operations about Checklists"
        },
		{
            "path": "checklist_items.json",
            "description": "Operations about Checklist items"
        },
		{
            "path": "activities_listing.json",
            "description": "Operations about Activities"
        },
		{
            "path": "organizations.json",
            "description": "Operations about Organizations"
        }
    ],
    "authorizations": {
        "oauth2": {
            "type": "oauth2",
            "scopes": [
                {
                    "scope": "email",
                    "description": "Access to your email address"
                },
                {
                    "scope": "pets",
                    "description": "Access to your pets"
                }
            ],
            "grantTypes": {
                "implicit": {
                    "loginEndpoint": {
                        "url": "http://petstore.swagger.wordnik.com/oauth/dialog"
                    },
                    "tokenName": "access_token"
                },
                "authorization_code": {
                    "tokenRequestEndpoint": {
                        "url": "http://petstore.swagger.wordnik.com/oauth/requestToken",
                        "clientIdName": "client_id",
                        "clientSecretName": "client_secret"
                    },
                    "tokenEndpoint": {
                        "url": "http://petstore.swagger.wordnik.com/oauth/token",
                        "tokenName": "access_code"
                    }
                }
            }
        }
    },
    "info": {
        "title": "Restyaboard API",
		"description": ""
    }
}';
?>