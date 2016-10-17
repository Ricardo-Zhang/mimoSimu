def log(text1,text2):
    def decorator(func):
        def wrapper(*args, **kw):
            print '%s  %s():' % (text1, func.__name__)
            return func(*args, **kw)
        return wrapper
        print text2
    return decorator


@log('begincall','endcall')
def now():
    print '2013-12-25'
now()
#print now()
#@log('endcall')
