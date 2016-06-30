/**
 * @fileOverview This file has functions related to setting view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: page view id.
 */
if (typeof App === 'undefined') {
    App = {};
}
App.SettingView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.id = options.id;
        this.getListing();
    },
    template: JST['templates/setting_list'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#js-setting-list-form': 'updateSetting',
        'click .js-import-users': 'importUsers',
    },
    /**
     * importUsers()
     * @return false
     */
    importUsers: function(e) {
        var importUsersUrl = api_url + 'users/import.json?token=' + api_token;
        $('.js-import-users').attr('disabled', true);
        $('#js-loader-img').removeClass('hide');
        var is_import_organizations = ($('#enableImportUsers').is(":checked")) ? true : false;
        var is_send_welcome_mail = ($('#dontSendWelcomeMail').is(":checked")) ? false : true;
        $.ajax({
            type: 'POST',
            data: {
                'is_import_organizations': is_import_organizations,
                'is_send_welcome_mail': is_send_welcome_mail
            },
            url: importUsersUrl,
            success: function(response) {
                if (response.success) {
                    if (is_import_organizations) {
                        self.flash('success', i18next.t('Users and organizations imported successfully.'));
                    } else {
                        self.flash('success', i18next.t('Users imported successfully.'));
                    }
                } else {
                    if (response.error === 'user_not_found') {
                        self.flash('danger', i18next.t('User records not available.'));
                    } else {
                        self.flash('danger', i18next.t('LDAP connection failed.'));
                    }
                }
                $('#js-loader-img').addClass('hide');
                $('.js-import-users').attr('disabled', false);
            },
            dataType: 'json'
        });
    },
    /**
     * updateSetting()
     * @return false
     */
    updateSetting: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        if (!_.isUndefined(data.DEFAULT_CARD_VIEW)) {
            DEFAULT_CARD_VIEW = data.DEFAULT_CARD_VIEW;
        }
        if (!_.isUndefined(data.LDAP_LOGIN_ENABLED) && $('.js-checkbox').is(":checked")) {
            data.LDAP_LOGIN_ENABLED = 'true';
        } else {
            if (parseInt(this.id) === 2) {
                data.LDAP_LOGIN_ENABLED = 'false';
            }
        }
        if (!_.isUndefined(data.STANDARD_LOGIN_ENABLED) && $('.js-checkbox').is(":checked")) {
            data.STANDARD_LOGIN_ENABLED = 'true';
        } else {
            if (parseInt(this.id) === 2) {
                data.STANDARD_LOGIN_ENABLED = 'false';
            }
        }
        data.ENABLE_SSL_CONNECTIVITY = 'false';
        if (!_.isUndefined($("input[name='ENABLE_SSL_CONNECTIVITY']:checked").val())) {
            data.ENABLE_SSL_CONNECTIVITY = 'true';
        }
        var self = this;
        var settingModel = new App.SettingCategory();
        settingModel.url = api_url + 'settings.json';
        settingModel.save(data, {
            success: function(model, response) {
                if (!_.isEmpty(response.success)) {
                    self.flash('success', i18next.t('Settings updated successfully.'));
                } else {
                    self.flash('danger', i18next.t('Settings not updated properly.'));
                }
            }
        });
        return false;
    },
    /** 
     * getListing()
     * get settings
     * @return false
     */
    getListing: function() {
        self = this;
        if (_.isUndefined(this.id)) {
            this.id = 3;
        }
        settingsCol = new App.SettingCategoryCollection();
        settingsCol.url = api_url + 'settings/' + this.id + '.json';
        settingsCol.fetch({
            cache: false,
            abortPending: true,
            success: function(collections, response) {
                self.render(collections);
            }
        });
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function(collections) {
        this.$el.html(this.template({
            list: collections,
            id: this.id
        }));
        $('.js-admin-setting-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-user-menu, .js-admin-email-menu, .js-admin-role-menu, .js-admin-board-menu').removeClass('active');
        return this;
    }
});
