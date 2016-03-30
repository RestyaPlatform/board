/**
 * @fileOverview This file has functions related to register view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Register View
 * @class RegisterView
 * @constructor
 * @extends Backbone.View
 */
App.RegisterView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/users_register'],
    tagName: 'article',
    className: 'clearfix',
    id: 'user-register',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#UserRegisterForm': 'register'
    },
    /**
     * register()
     * save user
     * @return false
     */
    register: function(e) {
        $('#submitRegister').attr('disabled', 'disabled');
        var target = $(e.target);
        var data = target.serializeObject();
        var self = this;
        var user = new App.User();
        user.url = api_url + 'users/register.json';
        user.save(data, {
            success: function(model, response) {
                if (response.error) {
                    if (response.error === 1) {
                        self.flash('danger', i18next.t('Email address already exist. Your registration process is not completed. Please, try again.'));
                    } else if (response.error === 2) {
                        self.flash('danger', i18next.t('Username already exists. Your registration process is not completed. Please, try again.'));
                    }
                    $('#inputPassword').val('');
                } else {
                    $('#submitRegister').removeAttr('disabled');
                    self.flash('success', i18next.t('You have successfully registered with our site and your activation mail has been sent to your mail inbox.'));
                    target[0].reset();
                }
            }
        });
        return false;
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template());
        this.showTooltip();
        return this;
    }
});
